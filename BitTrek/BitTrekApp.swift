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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accent)]
        
    }
    
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
