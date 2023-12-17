//
//  ImageView.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/15.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        ZStack {
            // フェッチ中 → ProgressViewを表示する
            // フェッチしてない → Imageを表示する
            if !viewModel.isFetching {
                // フェッチしてない
                // FIXME: 画像を直して!
//                Image(uiImage: viewModel.uiImage)
                Image("SampleImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            } else {
                // フェッチ中
                VStack {
                    ProgressView()
                    Text(viewModel.progressText)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ImageView(viewModel: ContentViewModel())
}
