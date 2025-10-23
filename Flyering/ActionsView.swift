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
import Combine

struct ActionsView: View {
    
    @EnvironmentObject var mapModel: MapViewModel
    @EnvironmentObject var state : Status
    
    // Timer to facilitate automatic view close.
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State private var timeout : Int = 0
    
    var body: some View {
        Text("Zone detail view")
        
            .navigationTitle(mapModel.selectedZone?.name ?? "??")
            .navigationBarTitleDisplayMode(.large)
            .onAppear() {
                print("actions view appears")
            }
            .onDisappear() {
                print("actions view disappears")
            }
            .onReceive(timer) { time in
                // Close the view after some time.
                timeout += 1
                if timeout > 5 {
                    state.showMenu = false
                }
            }


    }

}


