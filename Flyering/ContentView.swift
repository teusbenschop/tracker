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

    @State private var lastLatitude : CLLocationDegrees = 0
    @State private var lastLongitude : CLLocationDegrees = 0
    @State private var lastCourse : CLLocationDirection = 0
    @State private var lastLocation : CLLocation = CLLocation()

    @State private var tracking = false
    @State private var following = false;
    @State private var alwayson = false

    @State private var showingAlert = false
    
    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Menu {
                    Button("Park") {
                        print("Park")
                    }
                    Toggle("Drawing your track", isOn: $tracking)
                        .onChange(of: tracking) {
                            if tracking {
                            }
                            else {
                            }
                        }
                    Toggle("Map follows your location", isOn: $following)
                        .onChange(of: following) {
                            if following {
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

                Toggle(isOn: $tracking) {
                }
                .onChange(of: tracking) {
                    if tracking {
                        // Update location data once.
                        locationDataManager.checkLocationAuthorization()
                        // Update the map camera position at once without animation.
//                        updateMapCameraPosition()
                        //showingAlert = true
                    }
                    else {
                        //showingAlert = false
                    }
                }
                Image(systemName: "figure.walk")
                    .foregroundColor(tracking ? .green : .gray)

                
                Toggle(isOn: $following) {
                }
                .onChange(of: following) {
                    if following {
                        // Update location data once.
                        locationDataManager.checkLocationAuthorization()
                        // Update the map camera position at once without animation.
                        updateMapCameraPosition()
                        //showingAlert = true
                    }
                    else {
                        //showingAlert = false
                    }
                }
                Image(systemName: "location")
                    .foregroundColor(following ? .green : .gray)

                
                Toggle(isOn: $alwayson) {
                }
                .onChange(of: alwayson) {
                    UIApplication.shared.isIdleTimerDisabled = alwayson
                }
                Image(systemName: alwayson ? "lock.open.display" : "lock.display")
                    .foregroundColor(alwayson ? .green : .gray)


                    .alert("Enter your name", isPresented: $showingAlert) {
                        Button("OK", action: submit)
                    } message: {
                        Text("Xcode will print whatever you type.")
                    }

                Spacer()
            }
            
            WrapperView(view: mapViewModel.mapView)
                .onAppear() {
                    locationDataManager.checkLocationAuthorization()
                    updateMapCameraPosition()
                }
                
        }
        .onReceive(timer) { time in
            if following {
                updateMapCameraPosition()
            }
            if tracking {
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
    
    
    func updateMapCameraPosition() {
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

        // Set the camera.
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapViewModel.setCamera(coordinate, heading: course, animate: false)
    }

    
    func updateUserTrack()
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
