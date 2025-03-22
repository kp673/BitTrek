//
//  CoinModel.swift
//  BitTrek
//
//  Created by Kush Patel on 3/21/25.
//

import Foundation

/*
 import Foundation

 let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets")!
 var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
 let queryItems: [URLQueryItem] = [
   URLQueryItem(name: "order", value: "market_cap_desc"),
   URLQueryItem(name: "per_page", value: "250"),
   URLQueryItem(name: "page", value: "1"),
   URLQueryItem(name: "sparkline", value: "true"),
   URLQueryItem(name: "price_change_percentage", value: "24h"),
 ]
 components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

 var request = URLRequest(url: components.url!)
 request.httpMethod = "GET"
 request.timeoutInterval = 10
 request.allHTTPHeaderFields = [
   "accept": "application/json",
   "x-cg-demo-api-key": "CG-7hrWCaidJLLp3q3kQaTaZBis"
 ]

 let (data, _) = try await URLSession.shared.data(for: request)
 print(String(decoding: data, as: UTF8.self))
 */

typealias Coins = [Coin]

struct Coin: Codable, Identifiable {
    let id, symbol, name, image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    var currentHoldings: Double?
    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * currentPrice
    }
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
    
    mutating func updateCurrentHoldings(to amount: Double) {
        self.currentHoldings = amount
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
