//
//  ContentView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(.logoTransparent)
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
