//
//  LocationModel.swift
//  Swift-Map
//
//  Created by Steve Handy on 2025.03.23.
//

import Foundation
import MapKit

// Helper struct for map annotations
struct Location: Identifiable, Hashable {
    let id = UUID()
    let mapItem: MKMapItem

    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }

    var name: String {
        mapItem.name ?? "Unknown Location"
    }

    var address: String {
        let placemark = mapItem.placemark
        var addressString = ""

        if let thoroughfare = placemark.thoroughfare {
            addressString = thoroughfare
        }

        if let subThoroughfare = placemark.subThoroughfare {
            addressString = subThoroughfare + " " + addressString
        }

        if let locality = placemark.locality {
            addressString += ", " + locality
        }

        if let administrativeArea = placemark.administrativeArea {
            addressString += ", " + administrativeArea
        }

        return addressString
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
