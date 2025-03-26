//
//  Swift_MapApp.swift
//  Swift-Map
//
//  Created by Steve Handy on 2025.03.22.
//

import SwiftUI

@main
struct Swift_MapApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var mapViewModel = MapViewModel()

    var body: some Scene {
        WindowGroup {
			  if #available(iOS 17.0, *) {
				  ContentView()
					  .environmentObject(locationManager)
					  .environmentObject(mapViewModel)
			  } else {
				  // Fallback on earlier versions
			  }
        }
    }
}
