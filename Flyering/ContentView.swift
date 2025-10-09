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

    @StateObject var mapViewModel = MapViewModel()

    // This contains the camera position above the map.
    // The "automatic" value causes the map to open at a standard location.
    // If based in The Netherlands, the map will show that country.
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    // This would show the user location and the map would follow it.
    // @State private var mapCameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    
    @State private var lastLatitude : CLLocationDegrees = 0
    @State private var lastLongitude : CLLocationDegrees = 0
    @State private var lastCourse : CLLocationDirection = 0
    @State private var lastLocation : CLLocation = CLLocation()

    @State private var tracking = false
    
    @State private var alwayson = false

    @State private var showingAlert = false
    
    @State private var name = ""
    
    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            HStack {
                Spacer()

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
                    Toggle("Screen remains on", isOn: $alwayson)
                        .onChange(of: alwayson) {
                            if alwayson {
                            }
                            else {
                            }
                        }
                    Text(locationDataManager.locationInfo)
                    Button("Erase track") {
                        mapViewModel.eraseUserTrack()
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
                Spacer()





                Toggle(isOn: $alwayson) {
                    
                }
                .onChange(of: alwayson) {
                    UIApplication.shared.isIdleTimerDisabled = alwayson
                }
                Image(systemName: alwayson ? "lock.open.display" : "lock.display")
                    .foregroundColor(alwayson ? .green : .gray)

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
                Spacer()
            }
            
            WrapperView(view: mapViewModel.mapView)
                .onAppear() {
                    locationDataManager.checkLocationAuthorization()
                    updateMapCameraPosition(animate: false)
                    //                    viewModel.setAnnotation()
                    //                    Task {
                    //                        do {
                    //                            try await viewModel.displayRoutes()
                    //                        } catch {
                    //                            print(error)
                    //                        }
                    //                    }
                    //mapViewModel.setRegion(apeldoorn)
                    //mapViewModel.setCamera(apeldoorn, heading: 0.0, animate: false)
                    
                }
                .onLongPressGesture {
                }
                
        }
        .onReceive(timer) { time in
            if (tracking) {
                updateMapCameraPosition(animate: true)
                updateUserTrack()
            }
        }
        .onAppear {
            if (alwayson) {
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    

    func submit() {
        print("You entered")
    }
    
    
    func updateMapCameraPosition(animate: Bool) {
        // Get location data.
        let location = locationDataManager.location
        guard location != nil else { return }
        let latitude = location?.coordinate.latitude ?? 0
        let longitude = location?.coordinate.longitude ?? 0
        let course = (location?.course ?? 0)

        // Optimize performance: Proceed if there's a change.
        if (latitude == lastLatitude
            && longitude == lastLongitude
            && course == lastCourse) {
            return
        }
        lastLongitude = longitude
        lastLatitude = latitude
        lastCourse = course

        // Create camera.
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
        mapViewModel.setCamera(coordinate, heading: course, animate: animate)
    }

    
    func updateUserTrack() // Todo
    {
        // Get the location and make sure it's valid.
        let location : CLLocation? = locationDataManager.location
        guard location != nil else { return }
        
        // Get the distance from the previous location, whether it's large enough to draw it.
        let distanceMeters = location?.distance(from: lastLocation)
        if (distanceMeters ?? 0 < 2) { return }
        lastLocation = location ?? CLLocation()
        
        // Draw the new coordinate on the map.
        let coordinate = location?.coordinate
        guard coordinate != nil else { return }
        mapViewModel.updateUserTrack(coordinate ?? CLLocationCoordinate2D())
    }

    
    
}
