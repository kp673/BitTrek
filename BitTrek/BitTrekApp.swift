//
//  BitTrekApp.swift
//  BitTrek
//
//  Created by Kush Patel on 3/21/25.
//

import SwiftUI

@main
struct BitTrekApp: App {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
                    .environmentObject(viewModel)
            }
        }
    }
}
