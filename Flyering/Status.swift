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


final class Status: ObservableObject {
    
    // Whether to show the page with the actions.
    @Published var showActions : Bool = false

    // Whether to center the map on the user's location.
    @Published var goToUserLocation : Bool = false

    // Whether to set the screen to remain on always.
    @Published var screenOn = false
    
    // How the map tracks the user location.
    @Published var userTrackingMode: MKUserTrackingMode = .none
    
    // Whether to record the travelled track.
    @Published var recordTrack : Bool = false
    // Cache of waypoints still to draw.
    @Published var pendingTrack : [CLLocationCoordinate2D] = []
    
    // The journal.
    @Published var showJournal : Bool = false
    @Published var journalText : String = ""

}


extension Status {

    var followingLocation: Bool {
        get { userTrackingMode != .none }
        set (follow) {
            userTrackingMode = follow ? .follow : .none
        }
    }
    
    var followingDirection: Bool {
        get { userTrackingMode == .followWithHeading }
        set (follow) {
            userTrackingMode = follow ? .followWithHeading : .follow
        }
    }
    
    func log(item: String) {
        var fragment : String = ""
        if !journalText.isEmpty {
            fragment.append("\n")
        }
        fragment.append(item)
        journalText.append(fragment)
    }
}
