//
//  SearchBar.swift
//  Swift-Map
//
//  Created by Steve Handy on 2025.03.23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search for a location...", text: $text)
                .onSubmit(onSearch)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(9)
        .padding()
        .shadow(radius: 5)
    }
}

#Preview {
    SearchBar(text: .constant("San Francisco"), onSearch: {})
}
