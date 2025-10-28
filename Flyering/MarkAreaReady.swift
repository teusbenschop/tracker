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
    var annotations : [MKCircle] = []
    var polygon : MKPolygon? = nil

    func start(mapView: MKMapView) {
        
        // If the user has started a ready operation,
        // and has not completed the operation,
        // remove the data from the map.
        for annotation in annotations {
            mapView.removeAnnotation(annotation)
        }
        if polygon != nil {
            mapView.removeOverlay(polygon ?? MKPolygon())
        }

        // Clear any previous ready-related data.
        coordinates = []
        annotations = []

        // Determine the points, on the screen, where the octagon is to be placed.
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

        // Convert the screen points to coordinates on the map.
        // Draw the eight annotations on the map.
        // Store the coordinates and annotations in the object.
        let radius = CLLocationDistance(15) // Meters.
        for point in points {
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let annotation = MKCircle(center: coordinate, radius: radius)
            mapView.addAnnotation(annotation)
            coordinates.append(coordinate)
            annotations.append(annotation)
        }


        
        polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polygon ?? MKPolygon())

        
        
        
        

        
        
        
    }
    
}
