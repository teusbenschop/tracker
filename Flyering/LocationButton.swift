import SwiftUI

struct LocationButton: View {
    @EnvironmentObject var mapModel: MapViewModel
    var body: some View {
        Button(action: goToUserLocation) {
            Image(systemName: "location")
                .fontWeight(.medium)
        }
        .foregroundStyle(.blue)
        .frame(width: 50, height: 50)
        .background(.white.opacity(0.7))
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.4), radius: 10)
    }
    
    func goToUserLocation() {
        mapModel.goToUserLocation = true
        
        // This has to run after the button action ends (after the map view catches the signal)
        DispatchQueue.main.async {
            mapModel.goToUserLocation = false
        }
    }
}
