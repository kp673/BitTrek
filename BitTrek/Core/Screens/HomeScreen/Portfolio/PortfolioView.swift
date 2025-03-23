//
//  PortfolioView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HomeViewModel
    @FocusState var isFocused: Bool

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    SearchBarView(searchTerm: $viewModel.searchText)
                        .padding(16)
                    
                    CoinCardListView(selectedCoin: $viewModel.selectedCoin)
                    
                    if viewModel.selectedCoin != nil {
                        VStack(spacing: 20) {
                            HStack {
                                Text("Current Price of \(viewModel.selectedCoin?.symbol.uppercased() ?? "")")
                                Spacer()
                                Text(viewModel.selectedCoin?.currentPrice.asCurrencyUpto6Places() ?? "")
                            }
                            Divider()
                            HStack {
                                Text("Amount holding:")
                                Spacer()
                                TextField("Ex: 1.5", text: $viewModel.quantity)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                            }
                            Divider()
                            HStack {
                                Text("Current Value:")
                                Spacer()
                                Text("\(viewModel.getCurrentValue().asCurrencyUpto2Places())")
                            }
                            Divider()
                        }
                        .animation(.none, value: UUID())
                        .padding()
                        .font(.headline)
                    }
                }
                .onChange(of: viewModel.searchText) { _ , search in
                    if search.isEmpty {
                        viewModel.removeSelectedCoin()
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        UIApplication.shared.endEditing()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark")
                            .opacity(viewModel.showCheckMark ? 1 : 0)
                        
                        Button {
                            viewModel.saveButtonPressed()
                        } label: {
                            Text("Save".uppercased())
                        }
                        .opacity(
                            (viewModel.selectedCoin != nil && viewModel.selectedCoin?.currentHoldings != Double(viewModel.quantity)) ? 1 : 0
                        )
                    }
                    .font(.headline)
                }
            })
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}


struct CoinCardListView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var selectedCoin: Coin?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.portfolioCoins : viewModel.filteredResults) { coin in
                    CoinLogoCardView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.green : Color.clear , lineWidth: 1)
                        )
                }
                .onChange(of: viewModel.searchText) {
                    viewModel.handleSearchOnAllCoins()
                }
                .onChange(of: viewModel.selectedCoin?.id) {
                    UIApplication.shared.endEditing()
                }
            }
            .padding(.vertical, 8)
            .padding(.leading, 16)
        }
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }), let amount = portfolioCoin.currentHoldings {
            viewModel.quantity = "\(amount)"
        } else {
            viewModel.quantity = ""
        }
        
    }
}
