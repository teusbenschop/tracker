/*
 Copyright (©) 2025-2025 Teus Benschop.
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

import SwiftUI
import MapKit
import Combine
import Foundation
import CoreLocation


struct ContentView: View {

    @StateObject var locationDataManager = LocationDataManager()

    @StateObject var viewModel = ContentViewModel()

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
                Spacer()
                Button(action: {
                }) {
                    Image(systemName: "ellipsis")
                    Text("Dev")
                }
                .buttonStyle(.bordered)

                
                Toggle(isOn: $tracking) {
                }
                .onChange(of: tracking) {
                    if tracking {
                        // Update location data once.
                        locationDataManager.checkLocationAuthorization()
                        // If the tracking slider is moved to the "on" position,
                        // then update the map camera position at once without animation.
                        updateMapCameraPosition(animate: false)
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
                switch locationDataManager.locationStatus {
                case .none:
                    Image(systemName: "location.slash")
                        .foregroundColor(.red)
                case .inuse:
                    Image(systemName: "location")
                        .foregroundColor(.orange)
                        .opacity(tracking ? 1 : 0.5)
                case .always:
                    Image(systemName: "location")
                        .foregroundColor(.green)
                        .opacity(tracking ? 1 : 0.5)
                }
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
                    Text(locationDataManager.locationInfo)
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
                Spacer()
            }

//            if let coordinate = locationDataManager.lastKnownLocation {
//                Text("Latitude: \(coordinate.latitude)")
//                Text("Longitude: \(coordinate.longitude)")
//            } else {
//                Text("Unknown Location")
//            }
//            Button("Get location") {
//                locationDataManager.checkLocationAuthorization()
//            }
//            .buttonStyle(.borderedProminent)

            Map(position: $mapCameraPosition) {
//                let coordinates : [Coordinate] = createCoordinates()
//                ForEach(coordinates) { coordinate in
//                    Marker("", coordinate: coordinate.coordinate)
//                }
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton() // This makes location visible, to move to menu?
                MapCompass() // Move to menu as a button?
            }
            .onAppear {
                locationDataManager.checkLocationAuthorization()
                updateMapCameraPosition(animate: false)
            }
            .onLongPressGesture {
                print("long press")
            }
            .onChange(of: mapCameraPosition) { _, newLocation in
            }
            
            WrapperView(view: viewModel.mapView)
                .onAppear() {
                    print("map appears")
                    //                    viewModel.setAnnotation()
                    //                    Task {
                    //                        do {
                    //                            try await viewModel.displayRoutes()
                    //                        } catch {
                    //                            print(error)
                    //                        }
                    //                    }
                    viewModel.addCircle()
                    viewModel.setRegion(apeldoorn)
                }

            
        }
        .onReceive(timer) { time in
            if (tracking) {
                updateMapCameraPosition(animate: true)
            }
        }
    }
    

    func submit() {
        print("You entered")
    }
    
    
    func updateMapCameraPosition(animate: Bool) {
        let location = locationDataManager.lastKnownLocation
        if (location != nil) {
            let latitude = location?.coordinate.latitude ?? 0
            let longitude = location?.coordinate.longitude ?? 0
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let course = (location?.course ?? 0)
            let cameraPosition = MapCameraPosition.camera(
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
            if (animate) {
                withAnimation {
                    mapCameraPosition = cameraPosition
                }
            } else {
                mapCameraPosition = cameraPosition
            }
        }
    }

}


struct Coordinate : Identifiable {
    let id = UUID()
    let coordinate : CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}


func createCoordinates() -> [Coordinate] {
    let home = CLLocationCoordinate2D(latitude: 52.11041098408821, longitude: 6.06349499662067)
    var coordinates : [Coordinate] = []
    let count = 0...100
    for number in count {
        let d = Double(number)
        let longitude = home.longitude + (d * 0.0001)
        let c = CLLocationCoordinate2D(latitude: home.latitude, longitude: longitude)
        let coordinate : Coordinate = Coordinate(coordinate: c)
        coordinates.append(coordinate)
    }
    return coordinates
}
