//
//  OpenAI.swift
//  Parrotflow
//
//  Created by James Jackson on 7/1/23.
//

import Foundation

struct Message: Codable, Identifiable {
    var id = UUID()
    let role: String
    let content: String
    enum CodingKeys: String, CodingKey {
        case role, content
    }
}

struct RequestBody: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
}

struct ResponseMessage: Codable {
    let role: String
    let content: String
}

struct Choice: Codable {
    let message: ResponseMessage
    let finish_reason: String
    let index: Int
}

struct Completion: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: [String: Int]
    let choices: [Choice]
}

class OpenAI {
    
    static let modeName = "ChatGPT"
    static let model = true ? "gpt-3.5-turbo-16k" : "gpt-3.5-turbo"
    
    private let url = {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            fatalError("Invalid API URL")
        }
        return url
    }()
    
    private let apiKey = {
        return "<#YOUR_KEY_HERE#>"
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("OPENAI_API_KEY not found")
        }
        return apiKey
    }()
    
    private var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func predict(messageStore: MessageStore, temperature: Double = 0.7) async throws -> Completion {
        var req = self.request
        let body = RequestBody(model: Self.model, messages: messageStore.requestMessages(), temperature: temperature)
        let encoder = JSONEncoder()
        req.httpBody = try encoder.encode(body)
        let (data, _) = try await URLSession.shared.data(for: req)
        let decoder = JSONDecoder()
        let completion = try decoder.decode(Completion.self, from: data)
        return completion
    }
}
