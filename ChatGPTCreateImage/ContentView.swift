//
//  ContentView.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @FocusState var focas
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                LinearGradient(colors: [.mint, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .opacity(0.2)
                
                VStack {
                    Spacer()
                    
                    // 画像を表示する
                    ObtainedImageView(viewModel: self.viewModel)
                        .onTapGesture(perform: {
                            focas = false
                        })
                    
                    Spacer()
                    
                    // プロンプト入力欄
                    PromptView(viewModel: self.viewModel, focas: self._focas)
                }
                
            }
            .navigationTitle(viewModel.model)
        }
        // エラーが発生した時のアラート
        .alert("エラーが発生しました", isPresented: $viewModel.isShowErrorAlert) {
            Button(role: .cancel) {
                // 何もしないので処理はなし
            } label: {
                Text("何もしない")
            }
            Button {
                exit(-1)
            } label: {
                Text("アプリを終了する")
            }
            
        } message: {
            Text(viewModel.errorMessage ?? "エラーです")
        }
        // 保存に成功したことを知らせるアラート
        .alert("保存に成功しました", isPresented: $viewModel.isSuccessSaveAlert) {
            Button("OK") {
                viewModel.isSuccessSaveAlert = false
            }
        } message: {
            Text("画像の保存に成功しました")
        }
    }
}

#Preview {
    ContentView()
}
