import SwiftUI
import MapKit

struct MapViewNew: UIViewRepresentable {

    @EnvironmentObject var mapModel: MapViewModel
    @EnvironmentObject var locationModel: LocationManager

    func makeUIView(context: Context) -> MKMapView {

        let mapView = mapModel.mkMapView
        
        // Assign the coordinator (delegate).
        mapView.delegate = context.coordinator

        // Display all points of interest because these may assist as beacons during flyering.
        let configuration = MKStandardMapConfiguration()
        configuration.pointOfInterestFilter = .includingAll
        mapView.preferredConfiguration = configuration

        mapView.mapType = .standard
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true

        // Don't show the user tracking button because that interferes with the custom menu button.
        mapView.showsUserTrackingButton = false

        // Let the map open at the user's location for convenience.
        if let location = locationModel.location {
            mapView.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }

        // Draw all zones on the map.
        for zone in mapModel.naplesZones {
            let polygon = MKPolygon(coordinates: zone.vertices, count: zone.vertices.count)
            mapView.addOverlay(polygon)
            let annotation = MKPointAnnotation()
            annotation.coordinate = zone.labelLocation
            annotation.title = zone.name
            mapView.addAnnotation(annotation)
        }

        // Return the configured map.
        return mapView
    }


    // This is called if one of the observed objects changes.
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if mapModel.goToUserLocation, let location = locationModel.location {
            UIView.animate(withDuration: 0.5) {
                uiView.setRegion(
                    MKCoordinateRegion(
                        center: location.coordinate,
                        // Keep the current zoomlevel as the user may have adjusted it.
                        span: uiView.region.span
                    ),
                    animated: true
                )
            }
            
            // Check again whether or not the labels should be displayed!
            uiView.delegate?.mapView?(uiView, regionDidChangeAnimated: false)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // The Coordinator contains code for custom view appearance and behaviour.
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewNew
        
        init(_ parent: MapViewNew) {
            self.parent = parent
            super.init()
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleZoneTap))
            self.parent.mapModel.mkMapView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    
}

