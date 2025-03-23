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
    
    let coin: Coin
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct previewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
