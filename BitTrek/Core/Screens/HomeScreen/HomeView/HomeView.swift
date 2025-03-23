//
//  HomeView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/21/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(.all)
                .sheet(isPresented: $viewModel.showPortfolioView) {
                    PortfolioView()
                        .environmentObject(viewModel)
                }

            VStack {
                HeaderView(
                    showPortfolio: $viewModel.showPortfolio,
                    showPortfolioView: $viewModel.showPortfolioView)

                HomeStatsView(showPortfolio: $viewModel.showPortfolio)

                SearchBarView(searchTerm: $viewModel.searchText)
                    .padding(16)

                ListColumnTitles(showPortfolio: $viewModel.showPortfolio)

                if !viewModel.showPortfolio {
                    AllListView()
                        .transition(.move(edge: .leading))
                } else {
                    ZStack(alignment: .top) {
                        if viewModel.portfolioCoins.isEmpty
                            && viewModel.searchText.isEmpty
                        {
                            Text(
                                "You haven't added any coins to your portfolio yet!\n\nClick on the plus (+) icon in the top right corner to start adding coins!"
                            )
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.accent)
                            .font(.callout)
                            .fontWeight(.medium)
                            .padding(50)
                        } else {
                            PortfolioCoinsListView()
                        }
                    }
                    .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }

        }
        .onChange(of: viewModel.showPortfolio) {
            UIApplication.shared.endEditing()
            viewModel.searchText = ""
            viewModel.handleSortOptionChange()
        }
        //        .blur(radius: viewModel.isLoding ? 5 : 0)
        //        .overlay {
        //            ProgressView()
        //                .frame(width: 100, height: 100)
        //                .foregroundStyle(Color(.label))
        //                .background(
        //                    RoundedRectangle(cornerRadius: 8)
        //                        .fill(Color.gray)
        //                        .opacity(0.8)
        //                )
        //                .opacity(viewModel.isLoding ? 1 : 0)
        //        }
        .refreshable {
            if !viewModel.showPortfolio {
                Task {
                    await viewModel.refreshData(isRefreshing: true)
                }
            } else {
                viewModel.getPortfolioData()
            }
        }
        .navigationDestination(isPresented: $viewModel.showDetailView) {
            DetailSegueView(coin: $viewModel.selectedCoinForDetail)
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .toolbar(.hidden)
            .environmentObject(HomeViewModel())
    }
}

struct ListColumnTitles: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack(spacing: 1) {

            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        viewModel.sortOption == .rank
                            || viewModel.sortOption == .rankReversed ? 1 : 0
                    )
                    .rotationEffect(
                        .degrees(
                            viewModel.sortOption == .rankReversed ? 180 : 0))
            }
            .onTapGesture {
                switch viewModel.sortOption {
                case .rank:
                    withAnimation { viewModel.sortOption = .rankReversed }
                default:
                    withAnimation { viewModel.sortOption = .rank }
                }
            }

            Spacer()

            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(
                            viewModel.sortOption == .holdings
                                || viewModel.sortOption == .holdingsReversed
                                ? 1 : 0
                        )
                        .rotationEffect(
                            .degrees(
                                viewModel.sortOption == .holdingsReversed
                                    ? 180 : 0))
                }
                .onTapGesture {
                    switch viewModel.sortOption {
                    case .holdings:
                        withAnimation {
                            viewModel.sortOption = .holdingsReversed
                        }
                    default:
                        withAnimation { viewModel.sortOption = .holdings }
                    }
                }
            }
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(
                        viewModel.sortOption == .price
                            || viewModel.sortOption == .priceReversed ? 1 : 0
                    )
                    .rotationEffect(
                        .degrees(
                            viewModel.sortOption == .priceReversed ? 180 : 0))
            }
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
            .onTapGesture {
                switch viewModel.sortOption {
                case .price:
                    withAnimation { viewModel.sortOption = .priceReversed }
                default:
                    withAnimation { viewModel.sortOption = .price }
                }
            }
        }
        .font(.caption)
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal, 16)
        .onChange(of: viewModel.sortOption) {
            viewModel.handleSortOptionChange()
        }
        .onChange(of: viewModel.showPortfolio) { oldValue, _ in
            if oldValue {
                switch viewModel.sortOption {
                case .holdings, .holdingsReversed:
                    viewModel.sortOption = .rank
                default:
                    break
                }
            }
        }
    }
}
