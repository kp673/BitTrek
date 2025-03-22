//
//  HomeViewModel.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var showPortfolio: Bool = false
    @Published var showPortfolioView: Bool = false
    @Published var isLoding: Bool = false
    @Published var searchText: String = ""
    
    // MARK: Portfolio Edit View
    @Published var selectedCoin: Coin? = nil
    @Published var quantity: String = ""
    @Published var showCheckMark: Bool = false
    
    //MARK: Data From Api
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    @Published var filteredResults = [Coin]()
    @Published var statistics = [Statistics]()
    
    
    var marketData: MarketDataModel? = nil

    
    // MARK: - public get data calls
    func getCoins() async {
        do {
            if let coins: Coins = try await fetchCoins() {
                await MainActor.run {
                    self.allCoins = coins
                    self.filteredResults = coins
                }
            }
        } catch {
            print("Error fetching coins: \(error)")
        }
    }
    
    func getMarketData() async {
        do {
            let globalData: GlobalData? = try await fetchMarketData()
            self.marketData = globalData?.data
            await MainActor.run {
                self.updateStatistics()
            }
        } catch {
            print("Error fetching market Data: \(error)")
        }
    }
    
    // MARK: - User View Events
    func handleSearchOnAllCoins() {
        if searchText.isEmpty {
            withAnimation {
                filteredResults = allCoins
            }
        } else {
            withAnimation(.easeInOut(duration: 1)) {
                filteredResults = allCoins.filter({
                    $0.symbol.lowercased().contains(searchText.lowercased()) ||
                    $0.name.lowercased().contains(searchText.lowercased())
                })
            }
        }
    }
    
    func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        
        //save to portfolio
        
        //show checkmark
        withAnimation {
            showCheckMark = true
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showCheckMark = false
        }
    }
    
    
    //MARK: - UI Updates
    
    func updateStatistics() {
        guard let data = marketData else { return }
        
        let marketCap = Statistics(title: "Market Cap", value: data.marketCap, percentage: data.marketCapChangePercentage24HUsd)
        
        let volume = Statistics(title: "24h Volume", value: data.volume)
        
        let BTCDominance = Statistics(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = Statistics(title: "Portfolio Value", value: "0.00", percentage: 0)
        
        statistics.append(contentsOf: [
            marketCap,
            volume,
            BTCDominance,
            portfolio
        ])
    }
    
    //MARK: - Helpers
    func getCurrentValue() -> Double {
        if let quantity = Double(quantity){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    func removeSelectedCoin() {
        selectedCoin = nil
        searchText = ""
    }
    
    
    //MARK: - Fetch Data Calls
    private func fetchCoins() async throws -> Coins? {
// Use JSON to limit api quries for Testing
//        guard let coins: Coins = DataService.shared.loadJSONFromFile(fileName: "CoinResponse") else { return [] }
//        return coins
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets") else { throw CoinError.badURL }
        let queryComponents: [DataQueryComponents] = [
            .vsCurrency("usd"),
            .order("market_cap_desc"),
            .perPage(250),
            .page(1),
            .sparkline(true),
            .priceChangePercentage("24h")
        ]
        let headers = [
            "accept": "application/json",
            "x-cg-demo-api-key": ""
          ]
        do {
            let coins: Coins? = try await DataService.shared.get(url: url, headers: headers, queryComponents: queryComponents)
            return coins
        } catch {
            throw error
        }
    }
    
    private func fetchMarketData() async throws -> GlobalData? {
// Use JSON to limit api quries for Testing
        guard let globalData: GlobalData? = DataService.shared.loadJSONFromFile(fileName: "MarketDataResponse") else { return nil }
        return globalData
        
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { throw CoinError.badURL }
        let headers = [
            "accept": "application/json",
            "x-cg-demo-api-key": ""
          ]
        
        do {
            let globalData: GlobalData? = try await DataService.shared.get(url: url, headers: headers)
            return globalData
        } catch {
            throw error
        }
    }
}
