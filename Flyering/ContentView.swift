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
    // The "automatic" value causes the map to open at a standard location.
    // If based in The Netherlands, the map will show that country.
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    // This would show the user location and the map would follow it.
    // @State private var mapCameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)

    @State private var tracking = false

    @State private var showingAlert = false
    
    @State private var name = ""
    
    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {

            HStack {
               

                Toggle(isOn: $tracking) {
                    
                }
                .onChange(of: tracking) {
                    if tracking {
                        //showingAlert = true
                    }
                    else {
                        //showingAlert = false
                    }
                }
                .alert("Enter your name", isPresented: $showingAlert) {
                    Button("OK", action: submit)
                } message: {
                    Text("Xcode will print whatever you type.")
                }
                Image(systemName: "figure.walk")
                    .foregroundColor(tracking ? .green : .gray)
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
                if (tracking) {
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

func submit() {
    print("You entered")
}
