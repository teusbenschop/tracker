import SwiftUI
import MapKit

struct MapViewNew: UIViewRepresentable {

    @EnvironmentObject var mapModel: MapViewModel
    @EnvironmentObject var locationModel: LocationViewModel

    func makeUIView(context: Context) -> MKMapView {

        let mapView = mapModel.mkMapView
        
        // Assign the coordinator (delegate).
        mapView.delegate = context.coordinator
        
        mapView.region = MKCoordinateRegion(
            // The camera is initially centered in Naples, Italy.
            center: CLLocationCoordinate2D(latitude: 40.8522, longitude: 14.265),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        mapView.pointOfInterestFilter = .excludingAll
        mapView.mapType = .standard
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true

        // Draw all zones on the map.
        for zone in mapModel.naplesZones {
            let polygon = MKPolygon(coordinates: zone.vertices, count: zone.vertices.count)
            mapView.addOverlay(polygon)
            let annotation = MKPointAnnotation()
            annotation.coordinate = zone.labelLocation
            annotation.title = zone.name
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if mapModel.goToUserLocation, let location = locationModel.userLocation {
            UIView.animate(withDuration: 0.5) {
                uiView.setRegion(
                    MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
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

