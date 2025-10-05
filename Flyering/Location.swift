//
//  Location.swift
//  flyering
//
//  Created by Teus Benschop on 03/10/2025.
//


import SwiftUI
import MapKit
import Combine
import Foundation
import CoreLocation


enum LocationStatus {
    case none // No location information available.
    case inuse // Location information available if app is in the foreground, i.e. in use.
    case always // Location information always availble, also if app runs in background.
}

// Basic location manager object.
// This object is the delegate of the Core Location location manager.
// This object will pass updates to CLLocationManager to the app.
// On the iOS simulator, the location permissions can be set from the terminal:
// $ xcrun simctl privacy "iPhone 12" grant location-always org.bibledit.ios.test
class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()

    @Published var locationStatus : LocationStatus = .none
    @Published var locationInfo : String = ""
    @Published var authorizationStatus: CLAuthorizationStatus? // Todo no longer published.
    @Published var lastKnownLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        // If you need the most precise and regular location data,
        // you would want to call the startUpdatingLocation() function,
        // This is the most power-consuming option.
        // Other options, such as startMonitoringSignificantLocationChanges()
        // and startMonitoringVisits() are lower power,
        // but also not as precise or as frequently updated.
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            // Get a single, one time location data point.
            manager.requestLocation()
        case .authorizedAlways:
            authorizationStatus = .authorizedAlways
            manager.requestLocation()
        case .restricted:
            authorizationStatus = .restricted
        case .denied:
            authorizationStatus = .denied
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestAlwaysAuthorization()
        @unknown default:
            ()
        }
        updateLocationFeedback()
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first
    }

    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        locationStatus = .none
        locationInfo = error.localizedDescription
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
            lastKnownLocation = locationManager.location
        @unknown default:
            ()
        }
    }
    
    
    func updateLocationFeedback() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationStatus = .none
            locationInfo = "Please grant access to user location"
        case .restricted:
            locationStatus = .none
            locationInfo = "User location has been restricted"
        case .denied:
            locationStatus = .none
            locationInfo = "User location has been denied"
        case .authorizedAlways:
            locationStatus = .always
            locationInfo = "User location always available"
        case .authorizedWhenInUse:
            locationStatus = .inuse
            locationInfo = "User location available when app in use"
        @unknown default:
            locationStatus = .none
            locationInfo = "User location disabled"
        }
    }

}


