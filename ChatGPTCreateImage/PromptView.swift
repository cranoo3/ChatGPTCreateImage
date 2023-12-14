//
//  PromptView.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import SwiftUI

struct PromptView: View {
    @ObservedObject var viewModel: ContentViewModel
    @FocusState var focas: Bool
    
    var body: some View {
        ZStack {
            HStack {
                TextField("出力したい画像のプロンプトを入力", text: $viewModel.inputParameter)
                    .onSubmit {
                        if viewModel.fetchDecision() {
                            viewModel.fetchData()
                        }
                    }
                    .focused($focas)
                    .keyboardType(.webSearch)
                    .frame(height: 30)
                
                Button() {
                    viewModel.fetchData()
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                .disabled(!viewModel.fetchDecision())
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding()
    }
}

#Preview {
    PromptView(viewModel: ContentViewModel())
}
