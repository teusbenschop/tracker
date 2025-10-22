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


/*
enum LocationStatus {
    case none // No location information available.
    case inuse // Location information available if app is in the foreground, i.e. in use.
    case always // Location information always availble, also if app runs in background.
}


let please_grant_access_to_use_location = "Please grant access to user location"
let user_location_has_been_restricted = "User location has been restricted"
let user_location_has_been_denied = "User location has been denied"
let user_location_always_available = "User location always available"
let user_location_available_when_app_in_use = "User location available when app in use"
let user_location_disabled = "User location disabled"



// Basic location manager object.
// This object is the delegate of the Core Location location manager.
// This object will pass updates to CLLocationManager to the app.
// On the iOS simulator, the location permissions can be set from the terminal:
// $ xcrun simctl privacy "iPhone 12" grant location-always org.bibledit.ios.test
class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {

    private var locationManager = CLLocationManager()

    @Published var locationStatus : LocationStatus = .none
    @Published var locationInfo : String = ""
    @Published var location: CLLocation?
    
    private var counter : Int = 0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // If you need the most precise and regular location data,
        // you would want to call the startUpdatingLocation() function,
        // This is the most power-consuming option.
        // Other options, such as startMonitoringSignificantLocationChanges()
        // and startMonitoringVisits() are lower power,
        // but also not as precise or as frequently updated.
        locationManager.startUpdatingLocation()
    }

    
    // Tells the delegate when the app creates the location manager and when the authorization status changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            // Get a single, one time location data point.
            manager.requestLocation()
            manager.startUpdatingLocation()
        case .authorizedAlways:
            manager.requestLocation()
            manager.startUpdatingLocation()
        case .restricted:
            ()
        case .denied:
            ()
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        @unknown default:
            ()
        }
        updateLocationFeedback()
    }
    
    
    // Tells the delegate that the location manager was unable to retrieve a location value.
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        locationStatus = .none
        locationInfo = error.localizedDescription
    }
    

    // Tells the delegate that new location data is available.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        updateLocationFeedback()
        counter += 1
        //print(counter, "did update locations")
    }

    // Tells the delegate that updates will no longer be deferred.
    func locationManager(_ manager: CLLocationManager,
                         didFinishDeferredUpdatesWithError: (any Error)?) {
    }


    // Tells the delegate that location updates were paused.
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    }
    
    // Tells the delegate that the delivery of location updates has resumed.
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    }
    

    // Tells the delegate that the location manager received updated heading information.
    func locationManager(_ manager: CLLocationManager, didUpdateHeading: CLHeading) {
        print (didUpdateHeading)
    }


    // Asks the delegate whether the heading calibration alert should be displayed.
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return false
    }

    
    
    
    
    func checkLocationAuthorization() {
        updateLocationFeedback()
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            ()
        case .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            ()
        case .authorizedWhenInUse:
            location = locationManager.location
        @unknown default:
            ()
        }
    }
    

    // Update location feedback to be used in SwiftUI.
    // Make sure to not blindly set the feedback, as this causes redraws in SwiftUI.
    // Only update a feedback variable if needed.
    func updateLocationFeedback() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            if (locationStatus != .none) {
                locationStatus = .none
            }
            if (locationInfo != please_grant_access_to_use_location) {
                locationInfo = please_grant_access_to_use_location
            }
        case .restricted:
            if (locationStatus != .none) {
                locationStatus = .none
            }
            if (locationInfo != user_location_has_been_restricted) {
                locationInfo = user_location_has_been_restricted
            }
        case .denied:
            if (locationStatus != .none) {
                locationStatus = .none
            }
            if (locationInfo != user_location_has_been_denied) {
                locationInfo = user_location_has_been_denied
            }
        case .authorizedAlways:
            if (locationStatus != .always) {
                locationStatus = .always
            }
            if (locationInfo != user_location_always_available) {
                locationInfo = user_location_always_available
            }
        case .authorizedWhenInUse:
            if (locationStatus != .inuse) {
                locationStatus = .inuse
            }
            if (locationInfo != user_location_available_when_app_in_use) {
                locationInfo = user_location_available_when_app_in_use
            }
        @unknown default:
            if (locationStatus != .none) {
                locationStatus = .none
            }
            if (locationInfo != user_location_disabled) {
                locationInfo = user_location_disabled
            }
        }
    }
}
*/

