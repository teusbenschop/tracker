/*
 Copyright (©) 2025-2025 Teus Benschop.
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */


import SwiftUI
import MapKit
import Combine
import Foundation
import CoreLocation


let eerbeek = CLLocationCoordinate2D(latitude: 52.110602332448984, longitude: 6.063657565827189)
let delta = 0.05


// Generic wrapper for presenting the UIView type in SwiftUI’s View.
struct WrapperView<V: UIView>: UIViewRepresentable {
    typealias UIViewType = V
    
    var view: V
    
    init(view: V) {
        self.view = view
    }
    
    func makeUIView(context: Context) -> V {
        return view
    }
    
    func updateUIView(_ uiView: V, context: Context) {
        print(context)
    }
}



let apeldoorn = CLLocationCoordinate2D(latitude: 52.20845050042597, longitude: 5.97093032936879)
let deventer = CLLocationCoordinate2D(latitude: 52.24941011889572, longitude: 6.191191996121967)



// Describe the view model.
final class MapViewModel: NSObject, ObservableObject, MKMapViewDelegate {
    
    let mapView = MKMapView()
    
    override init() {
        super.init()
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        mapView.isRotateEnabled = true
        addGestureRecognizer()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.none, animated: false)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    }
    
    
    private func addGestureRecognizer() {
        let longTapgesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(longTapgesture)
    }
    
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let locationOnMap = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(locationOnMap, toCoordinateFrom: mapView)
        print("On long tap coordinates: \(coordinate)")
    }
    
    func setAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.title = "Centre"
        annotation.subtitle = "Apeldoorn"
        annotation.coordinate = apeldoorn
        mapView.addAnnotation(annotation)
    }
    
    func setRegion(_ coordinate: CLLocationCoordinate2D) {
        mapView.setRegion(MKCoordinateRegion(center: coordinate,
                                             latitudinalMeters: 2000,
                                             longitudinalMeters: 2000),
                          animated: true)
    }
    
    // Function for how to render an annotation on the map.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        // Current user location is annotation as well, so we leave its appearance as it is.
        if annotation === mapView.userLocation {
            annotationView?.annotation = annotation
            return annotationView
        }
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        let image = UIImage(systemName: "circle")?.withTintColor(.red)
        if (image != nil) {
            let size = 10.0
            UIGraphicsBeginImageContext(CGSizeMake(size, size))
            image!.draw(in: CGRectMake(0, 0, size, size))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = newImage
        }
        return annotationView
    }
    
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

    
    func updateUserTrack(_ coordinate: CLLocationCoordinate2D)
    {
        DispatchQueue.main.async() { [self] in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }

    
    func writeInitialUserTrack(coordinates : [CLLocationCoordinate2D])
    {
        DispatchQueue.main.async() { [self] in
            for coordinate in coordinates {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    func eraseUserTrack()
    {
        DispatchQueue.main.async() { [self] in
            mapView.removeAnnotations(mapView.annotations)
        }
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

