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
                HeaderView(showPortfolio: $viewModel.showPortfolio, showPortfolioView: $viewModel.showPortfolioView)
                
                HomeStatsView(showPortfolio: $viewModel.showPortfolio)
                
                
                SearchBarView(searchTerm: $viewModel.searchText)
                    .padding(16)
                
                
                ListColumnTitles(showPortfolio: $viewModel.showPortfolio)
                
                if !viewModel.showPortfolio {
                    AllListView()
                        .transition(.move(edge: .leading))
                } else {
                    PortfolioCoinsListView()
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            
        }
        .task {
            withAnimation { viewModel.isLoding = true}
            await viewModel.getCoins()
            await viewModel.getMarketData()
            withAnimation { viewModel.isLoding = false}
        }
        .blur(radius: viewModel.isLoding ? 5 : 0)
        .overlay {
            ProgressView()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color(.label))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .opacity(0.8)
                )
                .opacity(viewModel.isLoding ? 1 : 0)
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
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal, 16)
    }
}
