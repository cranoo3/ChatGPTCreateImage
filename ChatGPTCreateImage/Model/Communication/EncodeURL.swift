//
//  EncodeURL.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import Foundation

struct EncodeURL {
    // URLを作成
    func makeURLComponents(urlString: String) throws -> URLComponents {
        // String型をURL型に変換する
        var urlResult: Result<URL, Error> {
            if let tmpURL = URL(string: urlString) {
                return .success(tmpURL)
            } else {
                return .failure(CommunicationError.badURL)
            }
        }
        
        switch urlResult {
        case .success(let url):
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw CommunicationError.cannnotCreateURLComponents
            }
            return components
            
        case .failure(let error):
            throw error
        }
    }
}
