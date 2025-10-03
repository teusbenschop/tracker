//
//  Location.swift
//  flyering
//
//  Created by Teus Benschop on 03/10/2025.
//


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
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
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
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print ("didUpdateLocations")
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}

