//
//  CoinLogoView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

struct CoinLogoCardView: View {
    let coin: Coin
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: coin.image)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.accent)
                .lineLimit(1)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
                .lineLimit(2, reservesSpace: true)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 4)
    }
}
//
//#Preview {
//    CoinLogoView()
//}
