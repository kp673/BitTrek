//
//  HomeStatsView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { statistics in
                StatisticsView(stat: statistics)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(true))
        .environmentObject(HomeViewModel())
}
