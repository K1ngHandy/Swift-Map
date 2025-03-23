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
	@State private var position: MapCameraPosition = .automatic
	@State private var selectedLocationItem: Location? = nil

	var body: some View {
		ZStack {
			// Map view
			mapView

			// UI Elements
			overlayView
		}
		.onAppear(perform: setupInitialPosition)
		.onChange(of: locationManager.userLocation, perform: handleLocationChange)
	}

	private var mapView: some View {
		Map(position: $position, selection: $selectedLocationItem) {
			// User location marker
			UserAnnotation()

			// Location markers from search results
			ForEach(mapViewModel.locations.map { Location(mapItem: $0) }) { location in
				Marker(location.name, coordinate: location.coordinate)
					.tint(.red)
					.tag(location)
			}
		}
		.mapStyle(.standard)
		.onMapCameraChange { context in
			// Update region when map is moved
			let newRegion = MKCoordinateRegion(
				center: context.region.center, 
				span: context.region.span
			)
			mapViewModel.region = newRegion
		}
		.onChange(of: selectedLocationItem) { oldValue, newValue in
			if let location = newValue {
				mapViewModel.selectedLocation = location.mapItem
			}
		}
		.mapControls {
			// Add map controls
			MapUserLocationButton()
			MapCompass()
			MapScaleView()
		}
		.edgesIgnoringSafeArea(.all)
	}

	private var overlayView: some View {
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

	private func updateRegionFromContext(_ context: MapCameraUpdateContext) {
		let newRegion = MKCoordinateRegion(
			center: context.region.center, 
			span: context.region.span
		)
		mapViewModel.region = newRegion
	}
	
	private func setupInitialPosition() {
		if let userLocation = locationManager.userLocation?.coordinate {
			// Set initial camera position based on user location
			position = .region(MKCoordinateRegion(
				center: userLocation, 
				span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
			))
			mapViewModel.updateRegion(with: userLocation)
		}
	}

	private func handleLocationChange(_ oldValue: CLLocation?, _ newValue: CLLocation?) {
		if let coordinate = newValue?.coordinate {
			mapViewModel.updateRegion(with: coordinate)
		}
	}
}

#Preview {
	ContentView()
		.environmentObject(LocationManager())
		.environmentObject(MapViewModel())
}
