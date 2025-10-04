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


// Basic location manager object.
// This object is the delegate of the Core Location location manager.
// This object will pass updates to CLLocationManager to the app.
// On the iOS simulator, the app won't ask for permissions to use the location.
// This permission can be granted from the terminal:
// $ xcrun simctl privacy "iPhone 12" grant location-always org.bibledit.ios.test
class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var lastKnownLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are authorized and available.
            authorizationStatus = .authorizedWhenInUse
            manager.requestLocation()
            break
            
        case .authorizedAlways:  // Location services are authorized and available.
            authorizationStatus = .authorizedAlways
            // If you need the most precise and regular location data,
            // you would want to call the startUpdatingLocation() function,
            // This is the most power-consuming option.
            // Other options, such as startMonitoringSignificantLocationChanges()
            // and startMonitoringVisits() are lower power,
            // but also not as precise or as frequently updated.
            // Just now it uses the requestLocation() call,
            // which gets a single, one time location data point.
            // Insert code here of what should happen when Location services are
            manager.requestLocation()
            break;
            
        case .restricted:  // Location services currently unavailable.
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestAlwaysAuthorization()
            break
            
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print ("didUpdateLocations")
        lastKnownLocation = locations.first
        //?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    
    func checkLocationAuthorization() {

        switch locationManager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            //            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
           
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            lastKnownLocation = locationManager.location
            
        @unknown default:
            print("Location service disabled")
            
        }
    }

}


