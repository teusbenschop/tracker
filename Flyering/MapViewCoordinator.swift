import MapKit

extension MapViewUi.Coordinator {
 
    // This function overload specifies the appropiate renderer object for a given map overlay.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polygonOverlay = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygonOverlay)
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
 

    // This function overload specifies the appropiate UIView for a given map annotation.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let pointAnnotation = annotation as? MKPointAnnotation {
            if let existingView = mapView.dequeueReusableAnnotationView(withIdentifier: "waypoint") {
                return existingView
            }
            let annotationView = MKAnnotationView(annotation: pointAnnotation, reuseIdentifier: "waypoint")
            annotationView.canShowCallout = false
            annotationView.backgroundColor = .clear
            let image = UIImage(systemName: "circle")?.withTintColor(.red)
            if (image != nil) {
                let size = 10.0
                UIGraphicsBeginImageContext(CGSizeMake(size, size))
                image!.draw(in: CGRectMake(0, 0, size, size))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                annotationView.image = newImage
            }
            return annotationView
        }
        return nil
    }


    // This function overload runs every time the user finishes moving or zooming the map.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // The code below will hide annotations if zooming out beyond a limit.
        // The current annotations include the track, which should remain visible always.
//        let latitudeDelta = mapView.region.span.latitudeDelta
//        let threshold: CLLocationDegrees = 0.06
//        for annotation in mapView.annotations {
//            if let pointAnnotation = annotation as? MKPointAnnotation,
//               let annotationView = mapView.view(for: pointAnnotation) {
//                annotationView.isHidden = latitudeDelta > threshold
//            }
//        }
    }
    
    // The @objc decorator allows the function to be assigned to the tap gesture recognizer with the selector syntax.
    @objc func handleZoneTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let mapView = parent.mapModel.mkMapView
        let tapLocation = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        if let zone = parent.mapModel.zoneOfLocation(location) {
            parent.mapModel.selectedZone = zone
        }
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    }

}
