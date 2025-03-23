//
//  HeaderView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/21/25.
//

import SwiftUI

struct HeaderView: View {
    @Binding var showPortfolio: Bool  // Go to View
    @Binding var showPortfolioView: Bool  // Show edit VIew

    var body: some View {
        HStack {
            CircleButtonView(iconName: "plus")
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
                .opacity(showPortfolio ? 1 : 0)
                .onTapGesture {
                    if showPortfolio { showPortfolioView.toggle() }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }

        }
        .padding(.horizontal)
    }
}
