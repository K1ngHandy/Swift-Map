//
//  ContentView.swift
//  Swift-Map
//
//  Created by Steve Handy on 2025.03.22.
//

import SwiftUI
import MapKit

struct ContentView: View {
	@EnvironmentObject private var locationManager: LocationManager
	@EnvironmentObject private var mapViewModel: MapViewModel

	var body: some View {
		ZStack {
			// Map view
			Map(coordinateRegion: $mapViewModel.region, 
				showsUserLocation: true, 
				annotationItems: mapViewModel.locations.map { Location(mapItem: $0) }) { location in
				MapAnnotation(coordinate: location.coordinate) {
					Image(systemName: "mappin.circle.fill")
						.font(.title)
						.foregroundColor(.red)
						.onTapGesture {
							mapViewModel.selectedLocation = location.mapItem
						}
				}
			}
			.edgesIgnoringSafeArea(.all)

			// UI Elements
			VStack {
				// Search bar
				SearchBar(text: $mapViewModel.searchText, onSearch: mapViewModel.searchLocations)

				Spacer()

				// Selected location card
				if let selectedLocation = mapViewModel.selectedLocation {
					LocationCard(
						mapItem: selectedLocation, 
						onGetDirections: mapViewModel.getDirections, 
						onSave: {
							// Save functionality implemented later
						}
					)
				}
			}
		}
		.onAppear {
			if let userLocation = locationManager.userLocation?.coordinate {
				mapViewModel.updateRegion(with: userLocation)
			}
		}
	}
}

#Preview {
	ContentView()
		.environmentObject(LocationManager())
		.environmentObject(MapViewModel())
}
