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
            if viewModel.allCoins.isEmpty && viewModel.searchText.isEmpty {
                Text(
                    "There was an error fetching coins from the API \n\n swipe to refresh or try again later"
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.accent)
                .font(.callout)
                .fontWeight(.medium)
                .padding(50)
            } else {
                ForEach(
                    viewModel.searchText.isEmpty
                        ? viewModel.allCoins : viewModel.filteredResults
                ) { coin in
                    CoinListCellView(coin: coin, showHoldingsColumn: false)
                        .onTapGesture {
                            viewModel.seguetoCoinDetails(with: coin)
                        }

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
            ForEach(
                viewModel.searchText.isEmpty
                    ? viewModel.portfolioCoins
                    : viewModel.filteredPortfolioCoins
            ) { coin in
                CoinListCellView(coin: coin, showHoldingsColumn: true)
                    .onTapGesture {
                        viewModel.seguetoCoinDetails(with: coin)
                    }
            }
        }
        .listStyle(.inset)
        .onChange(of: viewModel.searchText) {
            viewModel.handleSearchOnPortfolioCoins()
        }
    }
}

#Preview {
    AllListView()
        .environmentObject(HomeViewModel())
}
