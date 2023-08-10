//
//  ParrotflowAPI.swift
//  Parrotflow
//
//  Created by James Jackson on 7/22/23.
//

import Foundation

struct Query: Encodable {
    
    struct Message: Encodable, Identifiable {
        var id = UUID()
        let role: String
        var content: String
        enum CodingKeys: String, CodingKey {
            case role, content
        }
    }
    let messages: [Message]
    let stream = true
}

struct Chunk: Decodable {
    
    struct Choice: Decodable {
        struct Delta: Decodable {
            let role: String?
            let content: String?
        }
        let delta: Delta
    }
    let choices: [Choice]
}

struct ParrotflowAPI {
    
    private let url = {
        guard let url = URL(string: "https://api.parrotflow.com/v1/chat/completions") else {
            fatalError("Invalid API URL")
        }
        return url
    }()
    
    func makeRequest(messages: [Query.Message]) throws -> URLRequest {
        let query = Query(messages: messages)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(query)
        return request
    }
    
    func parse(_ line: String) -> String? {
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2, components[0] == "data" else { return nil }
        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        if message == "[DONE]" {
            return ""
        } else {
            let chunk = try? JSONDecoder().decode(Chunk.self, from: message.data(using: .utf8)!)
            return chunk?.choices.first?.delta.content
        }
    }
}
