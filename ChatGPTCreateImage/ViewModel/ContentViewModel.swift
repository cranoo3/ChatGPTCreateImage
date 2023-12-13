//
//  ContentViewModel.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    /// 取得したデータが格納される
    var data: ChatGPTResponse
    /// データを取得する
    let client = APICliant()
    
    // MARK: - @Published
    /// データ取得中であることをユーザに知らせるフラグ
    @Published var isFetching: Bool
    /// エラー発生時にフラグを表示
    @Published var isShowErrorAlert: Bool
    /// エラーメッセージが入る
    @Published var errorMessage: String?
    /// 画像のurl(文字列)が入る
    @Published var imageUrlString: String
    /// 作りたい画像のプロンプトを入力する
    @Published var prompt: String
    /// 画像生成AIのモデルが入る
    @Published var model: String
    /// テキストフィールド用
    @Published var forTextField: String
    
    // MARK: - 初期化処理
    init() {
        data = ChatGPTResponse(created: 0, data: [Datum(url: "")])
        
        isFetching = false
        isShowErrorAlert = false
        imageUrlString = ""
        prompt = ""
        model = client.model.uppercased()
        forTextField = ""
    }
    
    // MARK: - fetchData
    @MainActor
    func fetchData() {
        Task {
            // Fetch中のフラグを立てる
            isFetching = true
            // プロンプトに代入
            prompt = forTextField
            // テキストフィールドを空にする
            forTextField.removeAll()
            // データ取得
            let result = await client.fetch(prompt: self.prompt)
            
            // 戻ってきた結果が良ければ情報を入れる
            switch result {
            case .success(let data):
                self.data = data
                imageUrlString = data.data.first?.url ?? "No ImageURL"
                
            case .failure(let error):
                isShowErrorAlert = true
                if let error = error as? CommunicationError {
                    errorMessage = error.message
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            
            // フラグを下す
            isFetching = false
        }
    }
    
    // MARK: - fetchDecision
    /// fetchが行えるか判定する
    func fetchDecision() -> Bool {
        // フェッチ中でもなくユーザーの入力が空でもない場合に行えるようにする
        if !(isFetching || forTextField.isEmpty) {
            return true
        }
        return false
    }
}
