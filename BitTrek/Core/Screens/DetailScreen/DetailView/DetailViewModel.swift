//
//  DetailViewModel.swift
//  BitTrek
//
//  Created by Kush Patel on 3/23/25.
//
import SwiftUI

@MainActor
final class DetailViewModel: ObservableObject {
    @Published var coinDetails: CoinDetail?
    @Published var overviewStatistics: [Statistics] = []
    @Published var additionalStatistics: [Statistics] = []
    var coin: Coin?

    //MARK: - Public Get Data Calls

    func getCoinDetails(for coin: Coin) async {
        self.coin = coin
        do {
            let details = try await fetchCoinDeails(for: coin.id)
            try await MainActor.run {
                guard let details else { throw CoinError.nilObject }
                self.coinDetails = details
                self.createStatistics(for: details)
            }
        } catch {
            print("Error fetching coins: \(error)")
        }
    }

    //MARK: - UI Updates

    func createStatistics(for coinDetails: CoinDetail) {
        guard let coin else { return }
        
        //Overview data
        let price = coin.currentPrice.asCurrencyUpto6Places()
        let priceChange = coin.priceChangePercentage24H
        let priceStat = Statistics(
            title: "Current Price", value: price, percentage: priceChange)

        let marketcap =
            "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistics(
            title: "Market Capitalization", value: marketcap,
            percentage: marketCapChange)

        let rank = "\(coin.rank)"
        let rankStat = Statistics(title: "Rank", value: rank)

        let volume = coin.totalVolume?.formattedWithAbbreviations() ?? ""
        let volumeStat = Statistics(title: "Volume", value: volume)

        
        //Additional Detail
        
        let high = coin.high24H?.asCurrencyUpto6Places() ?? "n/a"
        let highStat = Statistics(title: "High 24h", value: high)
        
        let low24H = coin.low24H?.asCurrencyUpto6Places() ?? "n/a"
        let low24HStat = Statistics(title: "Low 24h", value: low24H)
        
        let priceChange24H = coin.priceChange24H?.asCurrencyUpto6Places() ?? "n/a"
        let priceChangePercentage24H = coin.priceChangePercentage24H ?? 0.0
        let priceChange24HStat = Statistics(title: "Price Change 24h", value: priceChange24H, percentage: priceChangePercentage24H)
        
        let marketCapChange24H = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage24H = coin.marketCapChangePercentage24H ?? 0.0
        let marketCapChange24HStat = Statistics(title: "Market Cap Change 24h", value: marketCapChange24H, percentage: marketCapChangePercentage24H)
        
        let blockTimeInMinutes = coinDetails.blockTimeInMinutes ?? 0
        let blockTimeString = blockTimeInMinutes == 0 ? "n/a" : "\(blockTimeInMinutes)"
        let blockTimeInMinutesStat = Statistics(title: "Block Time (min)", value: "\(blockTimeString)")
        
        let hashingAlgorithm = coinDetails.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistics(title: "Hashing Algorithm", value: hashingAlgorithm)
        
        self.overviewStatistics = [
            priceStat, marketCapStat, rankStat, volumeStat,
        ]
        self.additionalStatistics = [
            highStat, low24HStat, priceChange24HStat, marketCapChange24HStat, blockTimeInMinutesStat, hashingStat
        ]
    }

    //MARK: - Private fetch
    private func fetchCoinDeails(for coinId: String) async throws -> CoinDetail?
    {

        guard
            let coinDetails: CoinDetail? = DataService.shared.loadJSONFromFile(
                fileName: "CoinDetail")
        else { return nil }
        return coinDetails

        guard
            let url = URL(
                string: "https://api.coingecko.com/api/v3/coins/\(coinId)")
        else { throw CoinError.badURL }

        let queryComponent: [DataQueryComponents] = [
            .localization(false),
            .tickers(false),
            .marketData(false),
            .communityData(false),
            .developerData(false),
            .sparkline(false),
        ]
        let headers = [
            "accept": "application/json",
            "x-cg-demo-api-key": "",
        ]

        do {
            let details: CoinDetail? = try await DataService.shared.get(
                url: url, headers: headers, queryComponents: queryComponent)

            return details
        } catch {
            throw error
        }
    }

}
