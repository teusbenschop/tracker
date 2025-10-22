import MapKit

extension ZonesMapView.Coordinator {
 
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
            if let existingLabel = mapView.dequeueReusableAnnotationView(withIdentifier: "ZoneLabel") {
                return reuseZoneLabel(existingLabel, for: pointAnnotation)
            }
            return createZoneLabel(for: pointAnnotation)
        }
        return nil
    }


    func reuseZoneLabel(_ annotationView: MKAnnotationView, for annotation: MKPointAnnotation) -> MKAnnotationView {
        guard let label = annotationView.subviews.first as? UILabel else {
            return annotationView
        }
        label.text = annotation.title ?? ""
        applyPadding(to: label)
        annotationView.frame = label.frame
        return annotationView
    }

    
    func createZoneLabel(for annotation: MKPointAnnotation) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "ZoneLabel")
        annotationView.canShowCallout = false
        annotationView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = annotation.title ?? ""
        label.textColor = .black
        label.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 8, weight: .bold)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        applyPadding(to: label)
        
        annotationView.addSubview(label)
        annotationView.frame = label.frame
        
        return annotationView
    }
    
    func applyPadding(to label: UILabel) {
        let paddingX: CGFloat = 8
        let paddingY: CGFloat = 6
        label.frame = CGRect(
            x: 0,
            y: 0,
            width: label.intrinsicContentSize.width + 2 * paddingX,
            height: label.intrinsicContentSize.height + 2 * paddingY
        )
        label.layer.cornerRadius = label.frame.height / 2
    }
   
    
    // This function overload runs every time the user finishes moving or zooming the map.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let latitudeDelta = mapView.region.span.latitudeDelta
        let threshold: CLLocationDegrees = 0.06
        
        for annotation in mapView.annotations {
            if let pointAnnotation = annotation as? MKPointAnnotation,
               let annotationView = mapView.view(for: pointAnnotation) {
                annotationView.isHidden = latitudeDelta > threshold
            }
        }
    }
}
