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

import MapKit


func toString(state: MKAnnotationView.DragState) -> String
{
    switch state {
    case .none:
        return "none"
    case .starting:
        return "starting"
    case .dragging:
        return "dragging"
    case .canceling:
        return "canceling"
    case .ending:
        return "ending"
    default:
        return "unknown"
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
