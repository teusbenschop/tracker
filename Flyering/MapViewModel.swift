import MapKit
import Combine


final class MapViewModel: ObservableObject {
    
    // Use the MKMapView class, not MapView, the SwiftUI equivalent.
    @Published var mkMapView = MKMapView()
    
    // Set the map mode whether to follow user location and/or direction.
    func setUserTrackingMode(userTrackingMode: MKUserTrackingMode) {
        mkMapView.setUserTrackingMode(userTrackingMode, animated: false)
    }
}
