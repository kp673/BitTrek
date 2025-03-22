//
//  AllListView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//
import SwiftUI

struct AllListView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinListCellView(coin: coin, showHoldingsColumn: false)
            }
        }
        .listStyle(.inset)
    }
}

struct PortfolioCoinsListView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinListCellView(coin: coin, showHoldingsColumn: true)
            }
        }
        .listStyle(.inset)
    }
}


#Preview {
    AllListView()
        .environmentObject(HomeViewModel())
}
