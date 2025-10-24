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

// Tutorials used:
// https://medium.com/@leocoronag/interactive-polygon-zones-in-mapkit-customizing-your-map-views-to-an-obsessive-extent-77943267ed10


@main
struct FlyeringApp: App {
    
    @StateObject private var mapModel = MapViewModel()
    @StateObject private var locationModel = LocationManager()
    @StateObject private var status = Status()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mapModel)
                .environmentObject(locationModel)
                .environmentObject(status)
        }
    }
}
