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


struct MainView: View {
    
    // Property wrappers for observable objects that the parent view supplies.
    @EnvironmentObject private var mapModel: MapViewModel
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var status: Status
    @EnvironmentObject private var trackManager: TrackManager

    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State private var lastLocation : CLLocation = CLLocation()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                MapViewUi()
                    .ignoresSafeArea()
                ButtonDisplayMenu()
                    .padding()
            }
            .navigationDestination(isPresented: $status.showActions) {
                ActionsView()
            }
            .navigationDestination(isPresented: $status.showJournal) {
                JournalView()
            }
        }
        .onAppear {
            if (status.screenOn) {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            status.log(item: "Main view appears")
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onReceive(timer) { time in
            if status.recordTrack {
                recordTrack()
            }
        }
    }
    
    func recordTrack() {
        // Get the location and make sure it's valid.
        let location : CLLocation? = locationManager.location
        guard location != nil else { return }
        
        // Get the distance from the previous location, whether it's large enough to draw it.
        let distanceMeters = location?.distance(from: lastLocation)
        if (distanceMeters ?? 0 < 2) { return }
        lastLocation = location ?? CLLocation()
        
        // Store the new coordinate in the database.
        // Store it in the State object (which will prompt the mapview to draw it on the map).
        let coordinate = location?.coordinate
        guard coordinate != nil else { return }
        trackManager.storeCoordinate(coordinate: coordinate ?? CLLocationCoordinate2D())
        status.pendingTrack.append(coordinate ?? CLLocationCoordinate2D())
    }
}



// Todo transfer essence to new.

/*
var locationStabilizationCounter : Int = 0


struct ContentViewOld: View {

    
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            Button("Park") {
                print("Park")
            }
            Button("Mark area as ready") {
                print("Mark area as ready")
                DispatchQueue.main.async() {

                }
                mapViewModel.markAreaAsReady()
            }

            
            WrapperView(view: mapViewModel.mapView)
                .onAppear() {
                    locationDataManager.checkLocationAuthorization()
                    updateMapCameraPosition()
                }
                .ignoresSafeArea()
                
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

    

}
*/

