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


import Combine
import MapKit


final class MarkAreaReady: ObservableObject {

    var coordinates : [CLLocationCoordinate2D] = []
    var annotations : [DraggableAnnotation] = []
    var polygon : MKPolygon? = nil

    func start(mapView: MKMapView) {

        // Determine the points on the screen where the octagon is to be placed.
        var points : [CGPoint] = []
        let windowOrigin : CGPoint = mapView.frame.origin
        let windowSize = mapView.frame.size
        let x = windowOrigin.x
        let y = windowOrigin.y
        let w = windowSize.width
        let h = windowSize.height
        points.append(CGPoint(x: x + w * 0.1, y: y + h * 0.2)) // Top left.
        points.append(CGPoint(x: x + w * 0.5, y: y + h * 0.1))
        points.append(CGPoint(x: x + w * 0.9, y: y + h * 0.2)) // Top right.
        points.append(CGPoint(x: x + w * 0.9, y: y + h * 0.5))
        points.append(CGPoint(x: x + w * 0.9, y: y + h * 0.8)) // Bottom right.
        points.append(CGPoint(x: x + w * 0.5, y: y + h * 0.9))
        points.append(CGPoint(x: x + w * 0.1, y: y + h * 0.8)) // Bottom left.
        points.append(CGPoint(x: x + w * 0.1, y: y + h * 0.5))

        // Convert the screen points to coordinates on the map and store those.
        points.enumerated().forEach {
            let point = $0.element
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            coordinates.append(coordinate)
        }
        
        // Place the annotations.
        placeAnnotations(mapView: mapView)

        // Draw the polygon.
        drawPolygon(mapView: mapView)
    }

    
    // Function to place the annotations on the map, based on the coordinates.
    func placeAnnotations (mapView: MKMapView) {
        // If the user has started a ready operation,
        // and has not completed the operation,
        // remove the annotations from the map and clear its data.
        for annotation in annotations {
            mapView.removeAnnotation(annotation)
        }
        annotations = []
        // Place annotations on the map at the coordinates and store them in the object.
        coordinates.enumerated().forEach {
            let index = $0.offset
            let coordinate = $0.element
            let annotation = DraggableAnnotation(coordinate: coordinate, index: index)
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }

    
    // Function to draw the polygon on the map, based on the coordinates.
    func drawPolygon (mapView: MKMapView) {
        // If the user has started a ready operation,
        // and has not completed the operation,
        // remove the polygon from the map and clear its data.
        if polygon != nil {
            mapView.removeOverlay(polygon ?? MKPolygon())
        }
        polygon = nil
        
        // Draw the polygon on the map to initially mark the area.
        polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polygon ?? MKPolygon())
    }

    
    // Get the diagonal distance of the map corners in meters.
    func mapDiagonalMeters (mapView: MKMapView) -> CLLocationDistance {
        let point1 = CGPoint(x: mapView.frame.origin.x, y: mapView.frame.origin.y)
        let point2 = CGPoint(x: mapView.frame.size.width, y: mapView.frame.size.height)
        let coordinate1 = mapView.convert(point1, toCoordinateFrom: mapView)
        let coordinate2 = mapView.convert(point2, toCoordinateFrom: mapView)
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2)
    }
    
    func selectPin (mapView: MKMapView, coordinate: CLLocationCoordinate2D) {
//        let longPressLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        print (longPressLocation)
//        var lastDistance = mapDiagonalMeters(mapView: mapView) / 20
//        for annotation in annotations {
//            let coordinate = annotation.coordinate
//            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            let distance = longPressLocation.distance(from: location)
//            print("distance", distance)
//            if distance < lastDistance {
//                lastDistance = distance
//                selectedVertex = annotation
//            }
//        }
//        print ("selected vertex", selectedVertex)
    }
    
}
