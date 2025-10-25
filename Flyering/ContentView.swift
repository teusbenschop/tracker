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
    
    // Property wrappers for observable objects that the parent view supplies.
    @EnvironmentObject var mapModel: MapViewModel
    @EnvironmentObject var locationModel: LocationManager
    @EnvironmentObject var status: Status
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                MapViewNew()
                    .ignoresSafeArea()
                ButtonDisplayMenu()
                    .padding()
            }
            .navigationDestination(isPresented: $status.showMenu) {
                ActionsView()
            }
            .onAppear {
                if (status.screenOn) {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}



// Todo transfer essence to new.

/*
var locationStabilizationCounter : Int = 0


struct ContentViewOld: View {

    @StateObject var locationDataManager = LocationDataManager()
    @State private var trackManager = TrackManager()

    @StateObject var mapViewModel = MapViewModel()

    @State private var lastLocation : CLLocation = CLLocation()

    @State private var drawingTrack = false
    @State private var userTracking : MKUserTrackingMode = .none

    @State private var aboutApp : String = "Flyering app version 1.0"

    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            HStack {

                Spacer()

                Menu {
                    Button("Park") {
                        print("Park")
                    }
                    Toggle("Drawing your track", isOn: $drawingTrack)
                    Button("Mark area as ready") {
                        print("Mark area as ready")
                        DispatchQueue.main.async() {

                        }
                        mapViewModel.markAreaAsReady()
                    }
                    Button("Erase track") {
                        mapViewModel.eraseUserTrack()
                        if (drawingTrack) {
                            trackManager.emptyDatabase()
                        } else {
                            trackManager.closeDatabase()
                            trackManager.eraseDatabase()
                        }
                    }
                    Text(locationDataManager.locationInfo)
                    Text(aboutApp)
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
                
                Button(action: {
                    drawingTrack = !drawingTrack
                }, label: {
                    Image(systemName: "road.lanes")
                        .foregroundColor(drawingTrack ? .red : .gray)
                        .fontWeight(drawingTrack ? .black : .light)
                })

                Spacer()

                Button(action: {
                    locationDataManager.checkLocationAuthorization()
                    handleTrackingModeButton()
                }, label: {
                    switch(userTracking) {
                    case .none:
                        Image(systemName: "location.slash")
                            .foregroundColor(.gray)
                    case .follow:
                        Image(systemName: "location.fill")
                            .foregroundColor(.red)
                    case .followWithHeading:
                        Image(systemName: "location.north.line.fill")
                            .foregroundColor(.red)
                    @unknown default:
                        Image(systemName: "location.slash")
                            .foregroundColor(.gray)
                    }
                })
                
                Spacer()
                

                Spacer()
            }
            
            WrapperView(view: mapViewModel.mapView)
                .onAppear() {
                    locationDataManager.checkLocationAuthorization()
                    updateMapCameraPosition()
                }
                .ignoresSafeArea()
                
        }
        .onReceive(timer) { time in
            if followingLocation {
            }
            if drawingTrack {
                updateUserTrack()
            }
        }
        .onAppear {
            let coordinates = trackManager.getAll()
            mapViewModel.writeInitialUserTrack(coordinates: coordinates)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                print("Active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
        .onChange(of: drawingTrack) {
            if drawingTrack {
                locationDataManager.checkLocationAuthorization()
                trackManager.openDatabase()
            } else {
                trackManager.closeDatabase()
            }
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
        let course = 0.0 // (location?.course ?? 0)

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
        
        // Store the new coordinate in the database.
        // Draw the new coordinate on the map.
        let coordinate = location?.coordinate
        guard coordinate != nil else { return }
        trackManager.storeCoordinate(coordinate: coordinate ?? CLLocationCoordinate2D())
        mapViewModel.updateUserTrack(coordinate ?? CLLocationCoordinate2D())
    }






}
*/

