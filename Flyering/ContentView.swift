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
    
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            distance: 200000000,
            heading: 0,
            pitch: 0
        )
    )

//    var annotations : [IdentifiableLocation] = [
//        IdentifiableLocation(id: ObjectIdentifier(MyClass(name: "London eye")), location: CLLocationCoordinate2D(latitude: 51.503399, longitude: -0.119519))
//    ]

   
    @State private var tracking = false

    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {

            HStack {

                switch locationDataManager.locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:  // Location services are available.
                    Text("Your current location is:")
                    Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                    Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                    
                case .restricted, .denied:  // Location services currently unavailable.
                    Text("Current location data was restricted or denied.")
                case .notDetermined:        // Authorization not determined yet.
                    Text("Finding your location...")
                    ProgressView()
                default:
                    ProgressView()
                }

                Image(systemName: "figure.walk")
                    .foregroundColor(.green)
                    .opacity(tracking ? 1 : 0)
                ProgressView()
                    .opacity(tracking ? 1 : 0)

                Menu {
                    Button("Park") {
                        print("Park")
                    }
                    Toggle("Flyering", isOn: $tracking)
                        .onChange(of: tracking) {
                            if tracking {
                            }
                            else {
                            }
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

            Map(position: $cameraPosition) {
            }
            .mapStyle(.standard)

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
                cameraPosition = MapCameraPosition.camera(
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
