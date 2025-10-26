// Todo transfer essence to new mapview.

/*

// Describe the view model.
final class MapViewModeldOld: NSObject, ObservableObject, MKMapViewDelegate {
    
    
    // Request one or more routes.
    func requestRoutes() async throws -> [MKRoute] {
        let startCoordinate = apeldoorn
        let finishCoordinate = deventer
        
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let finishPlacemark = MKPlacemark(coordinate: finishCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: finishPlacemark)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true // If false -> returns only one route
        request.tollPreference = .avoid
        request.highwayPreference = .any
        
        let directions = MKDirections(request: request)
        let response = try await directions.calculate()
        return response.routes
    }
    
    
    func displayRoutes() async throws {
        let routes = try await requestRoutes()
        //        for route in routes {
        //            await mapView.addOverlay(route.polyline)
        //        }
        guard let firstRoute = routes.first else { return }
        let polyline = firstRoute.polyline
        mapView.addOverlay(polyline)
        await setVisibleMapRect(for: firstRoute)
    }
    
    func setVisibleMapRect(for route: MKRoute) async {
        let edges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // Using the size of a route we can set the visible map rectangle.
        mapView.setVisibleMapRect(
            route.polyline.boundingMapRect,
            edgePadding: edges,
            animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle { // checking the type
            print("rendering circle")
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.systemBlue
            circle.fillColor = UIColor.systemBlue.withAlphaComponent(0.2)
            circle.lineWidth = 3
            return circle
        }
        else if let polygonOverlay = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygonOverlay)
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    func addCircle(_ coordinate: CLLocationCoordinate2D) {
        let circle = MKCircle(center: coordinate, radius: 100.0)
        mapView.addOverlay(circle)
    }
    
    
    func setCamera(_ coordinate: CLLocationCoordinate2D,
                   heading: CLLocationDirection,
                   animate: Bool) {
        // The distance from the camera to the center coordinate.
        // Take it from the existing camera if it exists, else take a default distance.
        // This enables the user to change the distance and the app will continue to use that.
        // Changing camera distance means that the user zooms the map.
        var distance : CLLocationDistance = mapView.camera.centerCoordinateDistance
        if (distance == 0) {
            distance = 4000
        }
        let camera = MKMapCamera(lookingAtCenter: coordinate,
                                 fromDistance: distance,
                                 pitch: 0.0,
                                 heading: heading)
        mapView.setCamera(camera, animated: animate)
    }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated: Bool) {
        //print ("region will change")
    }
    

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        //print("did change visible region")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        //print("region did change")
    }
    
    
    func setUserTrackingMode(mode : MKUserTrackingMode) {
        mapView.setUserTrackingMode(mode, animated: false)
    }
    
    
    func markAreaAsReady() {
        let region : MKCoordinateRegion = mapView.region
        let northWest = CLLocationCoordinate2D(
            latitude: region.center.latitude + region.span.latitudeDelta / 2.2,
            longitude: region.center.longitude - region.span.longitudeDelta / 2.2)
        let northEast = CLLocationCoordinate2D(
            latitude: region.center.latitude + region.span.latitudeDelta  / 2.2,
            longitude: region.center.longitude + region.span.longitudeDelta / 2.2)
        let southEast = CLLocationCoordinate2D(
            latitude: region.center.latitude - region.span.latitudeDelta / 2.2,
            longitude: region.center.longitude + region.span.longitudeDelta / 2.2)
        let southWest = CLLocationCoordinate2D(
            latitude: region.center.latitude - region.span.latitudeDelta / 2.2,
            longitude: region.center.longitude - region.span.longitudeDelta / 2.2)
        var coordinates : [CLLocationCoordinate2D] = []
        coordinates.append(northWest)
        coordinates.append(northEast)
        coordinates.append(southEast)
        coordinates.append(southWest)
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        polygon.title = "Eerbeek"
        polygon.subtitle = "home"
        mapView.addOverlay(polygon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = eerbeek
        annotation.title = "Eerbeek"
        mapView.addAnnotation(annotation)
    }
    
}
*/
