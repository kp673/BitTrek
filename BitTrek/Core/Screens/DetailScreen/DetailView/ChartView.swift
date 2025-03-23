//
//  ChartVIew.swift
//  BitTrek
//
//  Created by Kush Patel on 3/23/25.
//

import SwiftUI

struct ChartView: View {

    private let priceData: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startDate: Date
    private let endDate: Date
    @State private var percent: CGFloat = 0

    init(coin: Coin) {
        priceData = coin.sparklineIn7D?.price ?? []
        maxY = priceData.max() ?? 0
        minY = priceData.min() ?? 0
        let priceChange = (priceData.last ?? 0) - (priceData.first ?? 0)

        lineColor = priceChange > 0 ? Color.greenTheme : Color.redTheme

        endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }

    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(
                    chartYAxis.padding(.horizontal, 8), alignment: .leading)

            chartXAxis
                .padding(.horizontal, 8)
        }
        .font(.caption)
        .foregroundStyle(Color.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    self.percent = 1
                }
            }
        }
    }
}

struct ChartVIew_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {

    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in priceData.indices {
                    let xPosition =
                        (geometry.size.width / CGFloat(priceData.count))
                        * CGFloat(index + 1)

                    let yAxis = maxY - minY
                    let yPosition =
                        (1 - CGFloat((priceData[index] - minY) / yAxis))
                        * geometry.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percent)
            .stroke(
                lineColor,
                style: StrokeStyle(
                    lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }

    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }

    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let mid = (maxY + minY) / 2
            Text(mid.formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    private var chartXAxis: some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }
}
