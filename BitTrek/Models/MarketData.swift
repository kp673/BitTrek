//
//  MarketData.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$\(item.value.formattedWithAbbreviations())"
        } else {
            return ""
        }
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$\(item.value.formattedWithAbbreviations())"
        } else {
            return ""
        }
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: {
            $0.key == "btc"
        }) {
            return "\(item.value.asNumbersString())%"
        } else {
            return ""
        }
    }
    
}
