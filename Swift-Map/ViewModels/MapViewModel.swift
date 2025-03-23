//
//  MapViewModel.swift
//  Swift-Map
//
//  Created by Steve Handy on 2025.03.23.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3318, longitude: -121.8863),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var locations: [MKMapItem] = []
    @Published var selectedLocation: MKMapItem?
    @Published var searchText = ""
    @Published var showDirections = false
    @Published var routes: [MKRoute] = []

    func searchLocations() {
        guard !searchText.isEmpty else { return }

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = region

        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in 
            guard let self = self, let response = response else {
                print("Error searching: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.locations = response.mapItems

            //  Center map on first result
            if let firstItem = response.mapItems.first {
                withAnimation {
                    self.region.center = firstItem.placemark.coordinate
                }
            }
        }
    }

    func getDirections() {
        guard let selectedLocation = selectedLocation else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = selectedLocation
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in 
            guard let self = self, let route = response?.routes.first else {
                print("Error getting directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.routes = response?.routes ?? []
            self.showDirections = true
        }
    }

    func clearSearch() {
        searchText = ""
        locations = []
    }

    func updateRegion(with coordinate: CLLocationCoordinate2D) {
        region.center = coordinate
    }
}
