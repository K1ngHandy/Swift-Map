//
//  LocationCard.swift
//  Swift-Map
//
//  Created by Steve Handy on 2025.03.23.
//

import SwiftUI
import MapKit

struct LocationCard: View {
    let mapItem: MKMapItem
    var onGetDirections: () -> Void
    var onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(mapItem.name ?? "Unknown location")
                .font(.headline)

            if let address = mapItem.placemark.thoroughfare {
                Text(address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                Button {
                    onGetDirections()
                } label: {
                    Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                }
                .buttonStyle(.bordered)

                Spacer()

                Button {
                    onSave()
                } label: {
                    Label("Save", systemImage: "star")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(9)
        .padding()
        .shadow(radius: 5)
    }
}
