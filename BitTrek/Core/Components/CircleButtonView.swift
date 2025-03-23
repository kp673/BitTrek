//
//  CircleButtonView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/21/25.
//

import SwiftUI

struct CircleButtonView: View {

    let iconName: String

    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.accent)
            .frame(width: 50, height: 50)
            .background {
                Circle()
                    .foregroundStyle(Color.background)
            }
            .shadow(color: .accent.opacity(0.25), radius: 10)
            .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CircleButtonView(iconName: "info")
}
