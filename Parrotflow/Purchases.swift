//
//  StoreKit.swift
//  Parrotflow
//
//  Created by James Jackson on 7/2/23.
//

import SwiftUI
import StoreKit

class Purchases: ObservableObject {
    
    @AppStorage("hasPlus") var hasPlus: Bool = false
    
    enum Products: String, CaseIterable {
        case plus = "plus.monthly"
    }
    
    private var transactionObserverTask: Task<Void, Error>? = nil
    
    init() {
        transactionObserverTask = startObservingTransactions()
        Task {
            try await currentEntitlement(product: .plus)
        }
    }
    
    deinit {
        transactionObserverTask?.cancel()
    }
    
    func currentEntitlement(product: Products) async throws {
        switch await Transaction.currentEntitlement(for: product.rawValue) {
        case .verified(let transaction):
            let state = await transaction.subscriptionStatus?.state
            Task { @MainActor in
                hasPlus = state == .subscribed
            }
        case .unverified:
            break
        case .none:
            Task { @MainActor in
                hasPlus = false
            }
            break
        }
    }
    
    func purchase(product: Products) async throws {
        guard let product = try await Product.products(for: [product.rawValue]).first else {
            throw StoreKitError.notAvailableInStorefront
        }
        switch try await product.purchase() {
        case let .success(.verified(transaction)):
            await transaction.finish()
            Task { @MainActor in
                hasPlus = true
            }
        case .success(.unverified(_, _)):
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    func startObservingTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    Task { @MainActor [weak self] in
                        self?.hasPlus = true
                    }
                }
            }
        }
    }
}
