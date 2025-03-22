//
//  HomeView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/21/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State var showPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            
            VStack {
                HeaderView(showPortfolio: $showPortfolio)
                
                
                ListColumnTitles(showPortfolio: $showPortfolio)
                
                if !showPortfolio {
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
            await viewModel.getCoins()
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
