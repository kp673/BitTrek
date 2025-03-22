//
//  HomeViewModel.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var allCoins = [Coin]()
    @Published var portfolioCoins = [Coin]()
    
    @MainActor
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
}
