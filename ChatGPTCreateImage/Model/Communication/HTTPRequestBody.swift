//
//  HTTPRequestBody.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import Foundation

struct HTTPRequestBody: Codable {
    let model: String
    let prompt: String
    let n: Int
    let size: String
}
