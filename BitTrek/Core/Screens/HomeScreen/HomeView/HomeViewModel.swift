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
    @Published var isLoding: Bool = true
    @Published var searchText: String = ""
    @Published var sortOption: CoinSortOptions = .holdings
    
    // MARK: Portfolio Edit View
    @Published var selectedCoin: Coin? = nil
    @Published var quantity: String = ""
    @Published var showCheckMark: Bool = false
    
    //MARK: Data From Api
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    @Published var filteredResults = [Coin]()
    @Published var filteredPortfolioCoins: [Coin] = []
    @Published var statistics = [Statistics]()
    let portfolioDataService = PortfolioDataService()
    
    //MARK: Detail View
    @Published var selectedCoinForDetail: Coin? = nil
    @Published var showDetailView: Bool = false
    
    
    var marketData: MarketDataModel? = nil

    
    // MARK: - public get data calls
    func refreshData(isRefreshing: Bool) async {
        guard isRefreshing || allCoins.isEmpty else { return }
        await getCoins()
        await getMarketData()
        getPortfolioData()
    }
    
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
        } catch {
            print("Error fetching market Data: \(error)")
        }
    }
    
    func getPortfolioData() {
        let savedEntity = portfolioDataService.savedEntity
        let savedIds = savedEntity.map(\.coinId)
        allCoins.indices.forEach { index in
            guard let entity = savedEntity.first(where: { $0.coinId == allCoins[index].id }) else { return }
            allCoins[index].updateCurrentHoldings(to: entity.amount)
        }
        portfolioCoins = allCoins.filter { savedIds.contains($0.id) }
        self.updateStatistics()
        
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
    
    func handleSearchOnPortfolioCoins() {
        if searchText.isEmpty {
            withAnimation {
                filteredPortfolioCoins = portfolioCoins
            }
        } else {
            withAnimation(.easeInOut(duration: 1)) {
                filteredPortfolioCoins = portfolioCoins.filter({
                    $0.symbol.lowercased().contains(searchText.lowercased()) ||
                    $0.name.lowercased().contains(searchText.lowercased())
                })
            }
        }
    }
    
    func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        
        //save to portfolio
        portfolioDataService.updatePortfolio(coin: coin, amount: Double(quantity) ?? 0)
        
        //show checkmark
        withAnimation {
            showCheckMark = true
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showCheckMark = false
            self.getPortfolioData()
            self.updateStatistics()
        }
    }
    
    func handleSortOptionChange() {
        if showPortfolio {
            switch sortOption {
            case .rank:
                portfolioCoins.sort { $0.rank < $1.rank }
            case .rankReversed:
                portfolioCoins.sort { $0.rank > $1.rank }
            case .holdings:
                portfolioCoins.sort { $0.currentHoldingsValue > $1.currentHoldingsValue }
            case .holdingsReversed:
                portfolioCoins.sort { $0.currentHoldingsValue < $1.currentHoldingsValue }
            case .price:
                portfolioCoins.sort { $0.currentPrice > $1.currentPrice }
            case .priceReversed:
                portfolioCoins.sort { $0.currentPrice < $1.currentPrice }
            }
            return
        }
        if searchText.isEmpty {
            switch sortOption {
            case .rank:
                allCoins.sort { $0.rank < $1.rank }
            case .rankReversed:
                allCoins.sort { $0.rank > $1.rank }
            case .holdings:
                allCoins.sort { $0.currentHoldingsValue > $1.currentHoldingsValue }
            case .holdingsReversed:
                allCoins.sort { $0.currentHoldingsValue < $1.currentHoldingsValue }
            case .price:
                allCoins.sort { $0.currentPrice > $1.currentPrice }
            case .priceReversed:
                allCoins.sort { $0.currentPrice < $1.currentPrice }
            }
        } else {
            switch sortOption {
            case .rank:
                filteredResults.sort { $0.rank < $1.rank }
            case .rankReversed:
                filteredResults.sort { $0.rank > $1.rank }
            case .holdings:
                filteredResults.sort { $0.currentHoldingsValue > $1.currentHoldingsValue }
            case .holdingsReversed:
                filteredResults.sort { $0.currentHoldingsValue < $1.currentHoldingsValue }
            case .price:
                filteredResults.sort { $0.currentPrice > $1.currentPrice }
            case .priceReversed:
                filteredResults.sort { $0.currentPrice < $1.currentPrice }
            }
        }
    }
    
    func seguetoCoinDetails(with coin: Coin) {
        selectedCoin = coin
        showDetailView = true
    }
    
    
    //MARK: - UI Updates
    
    func updateStatistics() {
        guard let data = marketData else { return }
        
        let marketCap = Statistics(title: "Market Cap", value: data.marketCap, percentage: data.marketCapChangePercentage24HUsd)
        
        let volume = Statistics(title: "24h Volume", value: data.volume)
        
        let BTCDominance = Statistics(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        
//        let previousValue = portfolioCoins.map { coin in
//            let currentValue = coin.currentHoldingsValue
//            let precentChange = coin.priceChangePercentage24H ?? 0 / 100
//            let previousValue = currentValue / (1 + precentChange)
//            return previousValue
//        }.reduce(0 as Double, +)
//        
//        let percentChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistics(title: "Portfolio Value", value: portfolioValue.asCurrencyUpto2Places())
        
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
//        guard let globalData: GlobalData? = DataService.shared.loadJSONFromFile(fileName: "MarketDataResponse") else { return nil }
//        return globalData
//        
        
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
