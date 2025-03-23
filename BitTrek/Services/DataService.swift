//
//  DataService.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import Foundation

final class DataService: Sendable {
    static let shared = DataService()
    private init() {}

    func get<T: Codable>(
        url: URL, headers: [String: String]? = [:],
        queryComponents: [DataQueryComponents]? = nil
    ) async throws -> T? {
        guard
            var urlComponents = URLComponents(
                url: url, resolvingAgainstBaseURL: true)
        else { throw CoinError.badURL }
        urlComponents.queryItems = queryComponents?.map { $0.queryItem }

        do {
            return try await get(urlComponents: urlComponents, headers: headers)
        } catch {
            throw error
        }
    }

    private func get<T: Codable>(
        urlComponents: URLComponents, headers: [String: String]? = [:]
    ) async throws -> T {

        guard let enpointURL = urlComponents.url else { throw CoinError.badURL }

        var request = URLRequest(url: enpointURL)
        request.timeoutInterval = 10.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else { throw CoinError.invalidResponse }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch CoinError.invalidResponse {
            print(response)
            throw CoinError.invalidResponse
        } catch {
            print(error.localizedDescription)
            throw CoinError.decodingFailed
        }
    }

    func loadJSONFromFile<T: Decodable>(fileName: String) -> T? {
        guard
            let url = Bundle.main.url(
                forResource: fileName, withExtension: "json")
        else {
            print("Failed to locate \(fileName).json in bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase  // Adjust for key styles in JSON
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

}

enum CoinError: Error {
    case invalidResponse
    case decodingFailed
    case badURL
    case requestFailed
    case imageRetrivalFailed
    case nilObject
}

enum DataQueryComponents {
    case vsCurrency(String)
    case order(String)
    case perPage(Int)
    case page(Int)
    case sparkline(Bool)
    case priceChangePercentage(String)
    case localization(Bool)
    case tickers(Bool)
    case marketData(Bool)
    case communityData(Bool)
    case developerData(Bool)

    var name: String {
        switch self {
        case .vsCurrency: return "vs_currency"
        case .order: return "order"
        case .perPage: return "per_page"
        case .page: return "page"
        case .sparkline: return "sparkline"
        case .priceChangePercentage: return "price_change_percentage"
        case .localization: return "localization"
        case .tickers: return "tickers"
        case .marketData: return "market_data"
        case .communityData: return "community_data"
        case .developerData: return "developer_data"
        }
    }

    var queryItem: URLQueryItem {
        switch self {
        case .vsCurrency(let value),
            .order(let value),
            .priceChangePercentage(let value):
            return URLQueryItem(name: name, value: value)
        case .perPage(let value),
            .page(let value):
            return URLQueryItem(name: name, value: String(value))
        case .sparkline(let value),
            .localization(let value),
            .tickers(let value),
            .marketData(let value),
            .communityData(let value),
            .developerData(let value):
            return URLQueryItem(name: name, value: value ? "true" : "false")

        }
    }
}
