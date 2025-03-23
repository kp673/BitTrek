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
    @State private var showLaunchView: Bool = true
    
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accent)]
        
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                        .environmentObject(viewModel)
                }
                if showLaunchView {
                    launchView()
                        .transition(.move(edge: .trailing))
                }
            }
            .task {
                await viewModel.refreshData(isRefreshing: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showLaunchView.toggle()
                }
            }
        }
    }
}
