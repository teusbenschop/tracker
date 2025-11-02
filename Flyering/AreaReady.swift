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

        // Remove coordinates left over from a previous mark-ready operation.
        coordinates = []

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
        // and has not completed it,
        // remove the relevant annotations from the map.
        for annotation in mapView.annotations {
            if let draggableAnnotation = annotation as? DraggableAnnotation {
                mapView.removeAnnotation(draggableAnnotation)
            }
        }
        // Place annotations on the map at the calculated coordinates.
        coordinates.enumerated().forEach {
            let index = $0.offset
            let coordinate = $0.element
            let annotation = DraggableAnnotation(coordinate: coordinate, index: index)
            mapView.addAnnotation(annotation)
        }
    }

    
    // Function to draw the polygon on the map, based on the coordinates.
    func drawPolygon (mapView: MKMapView) {
        // If the user has started a ready operation,
        // and has not completed the operation,
        // remove the polygon from the map and clear its data.
        for polygon in mapView.overlays {
            if let readyPolygon = polygon as? ReadyPolygon {
                mapView.removeOverlay(readyPolygon)
            }
        }
        // Draw the polygon on the map to initially mark the area.
        let polygon = ReadyPolygon(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polygon)
    }
}


func getImageName(selected: Bool, dragging: Bool) -> String
{
    if selected {
        return "arrow.up.and.down.and.arrow.left.and.right"
    }
    return "circle.fill"
}


class DraggableAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var index: Int
    
    init(coordinate: CLLocationCoordinate2D, index: Int) {
        self.coordinate = coordinate
        self.index = index
        super.init()
    }
}


class DraggableAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            self.isDraggable = true
            self.canShowCallout = false
            updateAppearance()
        }
    }
    
    override func setDragState(_ newState: MKAnnotationView.DragState, animated: Bool) {
        super.setDragState(newState, animated: animated)
        updateAppearance()
    }
    
    private func updateAppearance() {
        let dragging = dragState != .none
        let scale: CGFloat = dragging ? 1.3 : 1.0
        let name = getImageName(selected: self.isSelected, dragging: dragging)
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.image = UIImage(systemName: name)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        }
    }
}


class ReadyPolygon: MKPolygon {
}
