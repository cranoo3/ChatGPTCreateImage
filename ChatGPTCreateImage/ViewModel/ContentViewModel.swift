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
    let client = APIClient()
    /// 画像を保存する
    let imageSaver = ImageSaver()
    /// URLを変換してくれる
    let encodeURL = EncodeURL()
    /// 画像のurl(文字列)が入る
    var imageUrlString: String
    
    // MARK: - @Published
    /// データ取得中であることをユーザに知らせるフラグ
    @Published var isFetching: Bool
    /// エラー発生時にフラグを表示
    @Published var isShowErrorAlert: Bool
    /// エラーメッセージが入る
    @Published var errorMessage: String?
    /// 画像のデータが入る
    @Published var uiImage: UIImage
    /// 作りたい画像のプロンプトを入力する
    @Published var prompt: String
    /// 画像生成AIのモデルが入る(navigationTitleで表示するため)
    @Published var model: String
    /// テキストフィールド用
    @Published var inputParameter: String
    /// ユーザに進捗状況を知らせるテキスト
    @Published var progressText: String
    /// 画像の保存に成功したことを知らせるアラートのフラグ
    @Published var isSuccessSaveAlert: Bool
    
    // MARK: - 初期化処理
    init() {
        data = ChatGPTResponse(created: 0, data: [Datum(url: "")])
        imageUrlString = ""
        
        isFetching = false
        isShowErrorAlert = false
        uiImage = UIImage()
        prompt = ""
        model = client.model.uppercased()
        inputParameter = ""
        progressText = ""
        isSuccessSaveAlert = false
    }
    
    // MARK: - fetchData
    @MainActor
    func fetchData() {
        Task {
            // MARK: Fetch中のフラグを立てる
            isFetching = true
            uiImage = UIImage()
            
            // MARK: プロンプトに代入
            prompt = inputParameter
            // テキストフィールドを空にして
            // 次のリクエストを送りやすくする
            inputParameter.removeAll()
            
            // MARK: ユーザにデータを取得中であることを知らせる
            progressText = "データを取得しています..."
            
            // MARK: データ取得
            let result = await client.fetch(prompt: self.prompt)
            // 戻ってきた結果が正しければ情報を入れる
            switch result {
            case .success(let data):
                self.data = data
                // 取得したデータから画像のURLを取り出す
                imageUrlString = data.data.first?.url ?? "No ImageURL"
                
            case .failure(let error):
                isShowErrorAlert = true
                if let error = error as? CommunicationError {
                    errorMessage = error.message
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            
            // MARK: ユーザに画像を取得中であることを知らせる
            progressText = "画像を取得しています..."
            
            // imageUrlStringからデータを取得する
            let imageDataResult = await client.fetchImageData(imageUrl: imageUrlString)
            // 戻ってきた結果が正しければ情報を入れる
            switch imageDataResult {
            case .success(let data):
                uiImage = data
                
            case .failure(let error):
                isShowErrorAlert = true
                if let error = error as? CommunicationError {
                    errorMessage = error.message
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            
            // MARK: Fetch中のフラグを下す
            isFetching = false
        }
    }
    
    // MARK: - fetchDecision
    /// fetchが行えるか判定する
    func fetchDecision() -> Bool {
        // フェッチ中でもなくユーザーの入力が空でもない場合に行えるようにする
        if !(isFetching || inputParameter.isEmpty) {
            return true
        }
        return false
    }
    
    // MARK: - saveImageDecision
    /// 画像の保存が行えるか判定する
    /// 保存できる → true
    /// 保存できない → false
    func saveImageDecision() -> Bool{
        if !(uiImage.size == .zero) {
            return true
        }
        return false
    }
    
    func saveImage() {
        // 保存に成功したらアラートを表示する
        if imageSaver.writeToPhotoAlbum(image: uiImage) {
            isSuccessSaveAlert = true
        }
    }
}
