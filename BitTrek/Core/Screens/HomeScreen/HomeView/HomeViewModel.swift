//
//  HomeViewModel.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    @Published var isLoding: Bool = false
    
    
    func getCoins() async {
        do {
            isLoding = true
            let coins: Coins = try await fetchCoins()
            self.allCoins = coins
            isLoding = false
        } catch {
            print("Error fetching coins: \(error)")
            isLoding = false
        }
    }
    
    
    private func fetchCoins() async throws -> Coins {
        
        if !IsDevBuild {
            guard let coins: Coins = DataService.shared.loadJSONFromFile(fileName: "CoinResponse") else { return [] }
            return coins
        }
        
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
            let coins: [Coin] = try await DataService.shared.get(url: url, headers: headers, queryComponents: queryComponents)
            return coins
        } catch {
            throw CoinError.requestFailed
        }
    }
}


let IsDevBuild = true
