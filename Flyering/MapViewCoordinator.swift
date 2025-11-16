import MapKit
import SwiftUI

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
            annotationView.isDraggable = true
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
        if annotation is DraggableAnnotation {
            let annotationView = DraggableAnnotationView(annotation: annotation, reuseIdentifier: "draggable")
            annotationView.isDraggable = true
            return annotationView
        }
        // Use a default view.
        return nil
    }


    // This function overload runs every time the user finishes moving or zooming the map.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // After the user interacts with the map,
        // and if the map were following the user's location,
        // the map switches this off.
        // Reset a counter to enable the app to switch it on again after a while.
        parent.status.userMapInteractionCountDown = 0
    }
    
    
    
    // The @objc decorator allows the function to be assigned to the tap gesture recognizer
    // with the selector syntax.
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
//        let mapView = parent.mapModel.mkMapView
//        let screenLocation = gestureRecognizer.location(in: mapView)
//        let location = mapView.convert(screenLocation, toCoordinateFrom: mapView)
//        if let zone = parent.mapModel.zoneOfLocation(location) {
//            parent.mapModel.selectedZone = zone
//        }
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
//        let mapView = parent.mapModel.mkMapView
//        let screenLocation = gestureRecognizer.location(in: mapView)
//        let coordinate = mapView.convert(screenLocation, toCoordinateFrom: mapView)
//        switch gestureRecognizer.state {
//        case .began:
//            parent.markAreaReady.selectPin(mapView: mapView, coordinate: coordinate)
//        case .changed:
//            print ("changed")
//        case .ended:
//            print ("ended")
//        default:
//            print ("other")
//        }
//        if let zone = parent.mapModel.zoneOfLocation(location) {
//            parent.mapModel.selectedZone = zone
//        }
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    }
    
    
    // The map view selected an annotation view.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let draggableView = view as? DraggableAnnotationView {
            view.image = UIImage(systemName: getImageName(view: draggableView, selected: view.isSelected, dragging: false))
        }
    }
    
    // The map view deselected an annotation view.
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let draggableView = view as? DraggableAnnotationView {
            view.image = UIImage(systemName: getImageName(view: draggableView, selected: view.isSelected, dragging: false))
        }
    }
    
    // The map view selected an annotation.
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        if let draggableAnnotation = annotation as? DraggableAnnotation {
            let index = draggableAnnotation.index
            if index == rejectIndex {
                self.parent.markAreaReady.clear(mapView: mapView)
            }
            if index == acceptIndex {
                self.parent.markAreaReady.accept(mapView: mapView)
            }
        }
    }
    
    // The map view deselected an annotation.
    func mapView(_ mapView: MKMapView, didDeselect annotation: any MKAnnotation) {
        guard annotation is DraggableAnnotation else { return }
    }
    
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState)
    {
        guard let annotation = view.annotation as? DraggableAnnotation else { return }
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .dragging:
            break
        case .ending:
            view.dragState = .none
            mapView.deselectAnnotation(annotation, animated: true)
            if annotation.index >= 0 {
                parent.markAreaReady.coordinates[annotation.index] = annotation.coordinate
                parent.markAreaReady.drawPolygon(mapView: mapView)
            }
        case .canceling:
            view.dragState = .none
            mapView.deselectAnnotation(annotation, animated: true)
        case .none:
            break
        default:
            break
        }
    }
    
    
}

