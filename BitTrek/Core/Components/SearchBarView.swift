//
//  SearchBarView.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//
import SwiftUI

struct SearchBarView: View {
    @Binding var searchTerm: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchTerm.isEmpty ? Color.secondaryText : Color.accent
                )
                .padding(.leading, 8)
            
            TextField("Search by name or symbol ...", text: $searchTerm)
                .autocorrectionDisabled(true)
                .submitLabel(.done)
                .keyboardType(.asciiCapable)
                .foregroundStyle(Color.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.small)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 8)
                        .opacity(searchTerm.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            withAnimation {
                                searchTerm = ""
                            }
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.background)
                .shadow(
                    color: .accent.opacity(0.25),
                    radius: 10
                )
        )
    }
}

#Preview {
    SearchBarView(searchTerm: .constant(""))
}
