//
//  StatisticsView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import SwiftUI

struct StatisticsView: View {
    let stat: Statistics
    
    var body: some View {
        VStack(spacing:5) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.accent)
            if let change = stat.percentage {
                HStack {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(.degrees(change < 0 ? 180 : 0))
                    
                    Text("\(change.asNumbersString())%")
                        .font(.caption)
                        .bold()
                }
                .foregroundStyle(
                    change < 0 ? Color.redTheme : Color.greenTheme
                )
            } else {
                Text("")
            }
        }
    }
}

#Preview {
    StatisticsView(stat: Statistics(title: "Market Cap", value: "$12.3B", percentage: 24.5))
}
