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
            ForEach(viewModel.filteredResults) { coin in
                CoinListCellView(coin: coin, showHoldingsColumn: false)
                    .onTapGesture {
                        viewModel.seguetoCoinDetails(with: coin)
                    }
                
            }
        }
        .listStyle(.inset)
        .onChange(of: viewModel.searchText) {
            viewModel.handleSearchOnAllCoins()
        }
    }
}

struct PortfolioCoinsListView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinListCellView(coin: coin, showHoldingsColumn: true)
                    .onTapGesture {
                        viewModel.seguetoCoinDetails(with: coin)
                    }
            }
        }
        .listStyle(.inset)
    }
}


#Preview {
    AllListView()
        .environmentObject(HomeViewModel())
}
