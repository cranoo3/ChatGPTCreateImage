//
//  ObtainedImageView.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import SwiftUI
import UIKit

struct ObtainedImageView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        ZStack {
            // onTapGestureでキーボードをしまえるようにするために背景色を追加している
            Color.white
                .opacity(0.01)
            
            VStack(alignment: .leading) {
                Text("プロンプト")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(viewModel.prompt)
                    .font(.title3)
                    .frame(minHeight: 30)
                
                Divider()
                
                Text("結果")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // 写真を表示する
                ImageView(viewModel: self.viewModel)
                
                Spacer()
                
                // 写真を保存するボタン
                Button(){
                    viewModel.saveImage()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("画像を保存する")
                    }
                    .padding()
                    .backgroundStyle(.ultraThinMaterial)
                }
                .disabled(!viewModel.saveImageDecision())
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .frame(alignment: .leading)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ObtainedImageView(viewModel: ContentViewModel())
}
