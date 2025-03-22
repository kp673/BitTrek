//
//  CachedAsyncImage.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: String
    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
    }

    private func loadImage() async {
        do {
            uiImage = try await ImageCacheManager.shared.loadImage(from: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    CachedAsyncImage(url: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")
}
