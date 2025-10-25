import MapKit
import Combine

// Method for linking data and views:
// 1. Create view model classes for the different features of the app.
// 2. These classes conform to the ObservableObject protocol.
// 3. Define singleton objects in the top of the view hierarchy with @StateObject.
// $. Pass the singletons down as environment objects.
// This frees the developer from the pain of bindings and general coupling in the code structure.

// Todo put this in file MapViewNew.swift.

final class MapViewModel: ObservableObject {
    
    // Use the MKMapView class, not MapView, the SwiftUI equivalent.
    @Published var mkMapView = MKMapView()
    @Published var selectedZone: Zone? = nil
    
    // The zones array is loaded from the JSON file.
    // It ignores many theoretically possible errors because they won't occur in this context.
    let naplesZones: [Zone] = {
        let url = Bundle.main.url(forResource: "Zones", withExtension: "json")!
        let decoder = JSONDecoder()
        return try! decoder.decode([Zone].self, from: Data(contentsOf: url))
    }()

    // Get a Zone object, if any, based on a location.
    func zoneOfLocation(_ location: CLLocationCoordinate2D) -> Zone? {
        for (index, overlay) in mkMapView.overlays.enumerated() {
            guard let polygon = overlay as? MKPolygon else { continue }
            
            let renderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint = MKMapPoint(location)
            let rendererPoint = renderer.point(for: mapPoint)
            if renderer.path.contains(rendererPoint) {
                return naplesZones[index]
            }
        }
        return nil
    }
    
    // Set the map mode whether to follow user location and/or direction.
    func setUserTrackingMode(userTrackingMode: MKUserTrackingMode) {
        mkMapView.setUserTrackingMode(userTrackingMode, animated: false)
    }
}
