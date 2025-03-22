//
//  LocalFileManager.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

final class ImageCacheManager: Sendable {
    
    static let shared = ImageCacheManager()
    private init() { }
    
    private let cache = URLCache(
        memoryCapacity: 25 * 1024 * 1024, // 25MB memory Cache
        diskCapacity: 100 * 1024 * 1024, // 100MB disk Cache
        diskPath: "imageCache"
    )
    
    func loadImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { throw CoinError.badURL}
        
        let request = URLRequest(url: url)
        if  let cachedResponse = cache.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw CoinError.invalidResponse}
        
            let cachedData = CachedURLResponse(
                response: httpResponse,
                data: data
            )
            cache.storeCachedResponse(cachedData, for: request)
            return UIImage(data: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
}
