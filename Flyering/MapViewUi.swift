import SwiftUI
import MapKit

struct MapViewUi: UIViewRepresentable {

    @EnvironmentObject var mapModel: MapViewModel
    @EnvironmentObject var locationModel: LocationManager
    @EnvironmentObject var status: Status
    @State private var previousUserTrackingMode: MKUserTrackingMode = .none


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

        // Do not track user initially (can be changed by the user).
        mapView.setUserTrackingMode(.none, animated: false)

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


    // This is called if any of the observed objects or their published members changes.
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // Handle focusing on user's location.
        if status.goToUserLocation, let location = locationModel.location {
            uiView.setRegion(
                MKCoordinateRegion(
                    center: location.coordinate,
                    // Keep the current zoomlevel as the user may have adjusted it.
                    span: uiView.region.span
                ),
                animated: false
            )
            // Check again whether or not the labels should be displayed.
            uiView.delegate?.mapView?(uiView, regionDidChangeAnimated: false)
        }
        
        // Handle change in user tracking mode.
        if status.userTrackingMode != previousUserTrackingMode {
            uiView.setUserTrackingMode(status.userTrackingMode, animated: false)
            DispatchQueue.main.async {
                previousUserTrackingMode = status.userTrackingMode
            }
        }
        
        // Check on and add the track to the map.
        if !status.pendingTrack.isEmpty {
            for coordinate in status.pendingTrack {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                uiView.addAnnotation(annotation)
            }
            DispatchQueue.main.async() {
                status.pendingTrack = []
            }
        }
        
        // Check on whether to erase the recorded track.
        if status.clearTrack {
            uiView.removeAnnotations(uiView.annotations)
            DispatchQueue.main.async() {
                status.clearTrack = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // The Coordinator contains code for custom view appearance and behaviour.
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewUi
        
        init(_ parent: MapViewUi) {
            self.parent = parent
            super.init()
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.parent.mapModel.mkMapView.addGestureRecognizer(tapRecognizer)
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            self.parent.mapModel.mkMapView.addGestureRecognizer(longPressRecognizer)
        }
    }
    
    
}

