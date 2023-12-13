//
//  ObtainedImageView.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/13.
//

import SwiftUI

struct ObtainedImageView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        ZStack {
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
                
                
                
                AsyncImage(url: URL(string: viewModel.imageUrlString)) { image in
                    VStack {
                        // 取得した画像
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    }
                } placeholder: {
                    if viewModel.isFetching {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ObtainedImageView(viewModel: ContentViewModel())
}
