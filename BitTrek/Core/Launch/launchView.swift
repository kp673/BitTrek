//
//  launchView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/23/25.
//

import SwiftUI

struct launchView: View {

    private let loadingText: [String] = "Loading  your  portfolio...".map {
        String($0)
    }
    @State private var showLoadingText: Bool = false

    private let timer = Timer.publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    @State private var counter: Int = 0
    @State var isActive: Bool = false

    var body: some View {
        ZStack {
            Color.launchBackground.ignoresSafeArea(.all)

            Image(.logoTransparent)
                .resizable()
                .frame(width: 300, height: 300)

            ZStack {
                if showLoadingText {
                    HStack(spacing: 1) {
                        ForEach(loadingText.indices, id: \.self) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.launchAccent)
                                .offset(y: counter == index ? -15 : 0)
                        }
                    }
                    .transition(.scale.animation(.easeIn))
                }
            }
            .offset(y: 150)
        }
        .onAppear {
            isActive = true
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            if isActive {
                withAnimation(.spring()) {
                    if counter == loadingText.count {
                        counter = 0
                    }
                    counter += 1
                }
            }
        }
        .onDisappear {
            isActive = false
        }
    }
}

#Preview {
    launchView()
}
