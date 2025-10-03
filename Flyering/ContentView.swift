//
//  ContentView.swift
//
//  Created by Teus Benschop on 01/10/2025.
//

import SwiftUI
import MapKit
import Combine
import Foundation
import CoreLocation


struct ContentView: View {

    @StateObject var locationDataManager = LocationDataManager()

    // This contains the camera position above the map.
    // The "automatic" value causes the map to open at a standard location,
    // like showing an entire country like The Netherlandsn, or another entire region.
    @State private var mapCameraPosition: MapCameraPosition = .automatic

    @State private var tracking = false

    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {

            HStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(.green)
                    .opacity(tracking ? 1 : 0)
                ProgressView()
                    .opacity(tracking ? 1 : 0)

                Menu {
                    Button("Park") {
                        print("Park")
                    }
                    Toggle("Tracking", isOn: $tracking)
                        .onChange(of: tracking) {
                            if tracking {
                            }
                            else {
                            }
                        }
                    switch locationDataManager.locationManager.authorizationStatus {
                    case .authorizedWhenInUse:
                        Text("Using location when in use")
                    case .authorizedAlways:
                        Text("Using location always")
                    case .restricted:
                        Text("Current location restricted")
                    case .denied:
                        Text("Current location denied")
                    case .notDetermined:
                        Text("Locating...")
                    default:
                        Text("Locating...")
                    }
                } label: {
                    Circle()
                        .fill(.gray.opacity(0.15))
                        .frame(width: 30, height: 30)
                        .overlay {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 13.0, weight: .semibold))
                                .foregroundColor(.pink)
                        }
                }

            }

            Map(position: $mapCameraPosition) {
                
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            // Long press gesture changes the selected location randomly
            .onLongPressGesture {
                
            }
//            .onChange(of: selectedLocation) { _, newLocation in
//            }
        }
        .onReceive(timer) { time in
            let location = locationDataManager.locationManager.location
            if (location != nil) {
                let latitude = location?.coordinate.latitude ?? 0
                let longitude = location?.coordinate.longitude ?? 0
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let course = location?.course ?? 0
                mapCameraPosition = MapCameraPosition.camera(
                    MapCamera(
                        centerCoordinate: coordinate,
                        // The distance from the center point of the map to the camera, in meters.
                        distance: 2000,
                        // The heading of the camera, in degrees, relative to true north.
                        heading: course,
                        // The viewing angle of the camera, in degrees.
                        pitch: 0
                    )
                )
            }
        }
    }
}

struct IdentifiableLocation: Identifiable {
    var id: ObjectIdentifier
    var location: CLLocationCoordinate2D
}

class MyClass {
    var name: String
    init(name: String) {
        self.name = name
    }
}
