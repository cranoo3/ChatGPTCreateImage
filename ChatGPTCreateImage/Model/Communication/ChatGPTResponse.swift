//
//  ChatGPTResponse.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import Foundation

// MARK: - ChatGPTResponse
struct ChatGPTResponse: Codable {
    let created: Int
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let url: String
}
