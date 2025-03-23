//
//  DetailView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/23/25.
//

import SwiftUI

struct DetailSegueView: View {
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            }
        }
    }
}


struct DetailView: View {
    @StateObject var viewModel = DetailViewModel()
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let coin: Coin
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(edges: .all)
            ScrollView {
                VStack {
                    ChartView(coin: coin)
                        .padding(.top, 16)
                    VStack(spacing: 10) {
                        
                        overviewTitle
                        Divider()
                        overviewGrid
                        
                        additionalTitle
                        Divider()
                        additionalGrid
                    }
                    .padding(16)
                }
            }
            .navigationTitle(coin.name)
        }
        .task {
            await viewModel.getCoinDetails(for: coin)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarImage
            }
        }
    }
}

struct previewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    
    private var toolBarImage: some View {
        HStack {
            CachedAsyncImage(url: coin.image)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.secondaryText)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: 30
        ) {
            ForEach(viewModel.overviewStatistics) { stat in
                StatisticsView(stat: stat)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: 30
        ) {
            ForEach(viewModel.additionalStatistics) { stat in
                StatisticsView(stat: stat)
            }
        }
    }
    
    
}
