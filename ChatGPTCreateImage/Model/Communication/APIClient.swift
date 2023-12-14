//
//  APICliant.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import Foundation
import UIKit

struct APIClient {
    // MARK: - PlistのValueを取得する
    let urlString = GetPlistValue.shared.getUrlString()
    let apiKey = GetPlistValue.shared.getApiKey()
    let organizationID = GetPlistValue.shared.getOrganizationID()
    let model = GetPlistValue.shared.getGPTModel()
    
    // MARK: - URLを作成するstruct
    /// ## 使い方
    /// ```swift: Swift
    /// encodeUrl.makeURLComponents(urlString: "変換したいURL")
    /// ```
    /// でStringからURLComponentsを作成する
    let encodeUrl = EncodeURL()
    
    // MARK: - Fetch
    func fetch(prompt: String) async -> Result<ChatGPTResponse, Error> {
        do {
            guard let url = try encodeUrl.makeURLComponents(urlString: self.urlString).url else {
                return .failure(CommunicationError.cannotCreateURL)
            }
            
            // MARK: httpBodyを作成
            var requestBody: Data? {
                // MARK: サンプルデータ
                let encodeValue = HTTPRequestBody(model: model, prompt: prompt, n: 1, size: "1024x1024")
                return try? JSONEncoder().encode(encodeValue)
            }
            
            // MARK: URLリクエストを作成
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = ["Authorization" : "Bearer \(apiKey)"
                                              ,"OpenAI-Organization": organizationID
                                              ,"Content-Type" : "application/json"]
            urlRequest.httpBody = requestBody
            
            guard let (data, urlRequest) = try? await URLSession.shared.data(for: urlRequest) else {
                return .failure(CommunicationError.badURL)
            }
            print(String(data: data, encoding: .utf8) ?? "")
            
            // MARK: 情報を受け取る
            guard let response = urlRequest as? HTTPURLResponse else {
                return .failure(CommunicationError.responseNotReturned)
            }
            
            guard 200..<300 ~= response.statusCode else {
                return .failure(CommunicationError.badStatusCode(response.statusCode))
            }
            
            // MARK: 受け取ったJSONをStructに格納する
            let decodeData = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
            return .success(decodeData)
            
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - fetchImageData
    /// urlの文字列からデータを取得する
    func fetchImageData(imageUrl: String) async -> Result<UIImage, Error> {
        guard let url = try? encodeUrl.makeURLComponents(urlString: imageUrl).url else {
            return .failure(CommunicationError.cannotCreateURL)
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            return .failure(CommunicationError.badURL)
        }
        
        guard let uiImageData = UIImage(data: data) else {
            return .failure(CommunicationError.fetchError)
        }
        
        return .success(uiImageData)
    }
}
