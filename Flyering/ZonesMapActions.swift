import UIKit
import MapKit

extension ZonesMapView.Coordinator {

    // The @objc decorator allows the function to be assigned to the tap gesture recognizer with the selector syntax.
    @objc func handleZoneTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let mapView = parent.mapModel.mkMapView
        let tapLocation = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        if let zone = parent.mapModel.zoneOfLocation(location) {
            parent.mapModel.selectedZone = zone
        }
    }
}

