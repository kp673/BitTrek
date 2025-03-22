//
//  CoinRowView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

struct CoinListCellView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
                .frame(minWidth: 30)
            
            
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } placeholder: {
                Image(.appLogoSVG)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(Color(.blue))
                    .clipShape(Circle())
            }
            
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.accent)
            
            Spacer()
            
            if showHoldingsColumn {
                HoldingView(coin: coin)
            }
            
            PriceView(coin: coin)
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListCellView(coin: dev.coin, showHoldingsColumn: true)
    }
}

struct HoldingView: View {
    let coin: Coin
    var body: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyUpto2Places())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumbersString())
        }
        .foregroundStyle(Color.accent)
    }
}

struct PriceView: View {
    let coin: Coin
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyUpto6Places())
                .bold()
                .foregroundStyle(Color.accent)
            Text("\(coin.priceChangePercentage24H?.asNumbersString() ?? "")%")
                .foregroundStyle(
                    coin.priceChangePercentage24H ?? 0 >= 0 ? Color.greenTheme : Color.redTheme
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
    }
}
