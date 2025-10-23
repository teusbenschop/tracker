import SwiftUI

struct MenuButton: View {
    @EnvironmentObject var status: Status
    var body: some View {
        Button(action: {status.showMenu = true}) {
            Image(systemName: "ellipsis")
                .fontWeight(.medium)
        }
        .foregroundStyle(.blue)
        .frame(width: 50, height: 50)
        .background(.white.opacity(0.7))
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.4), radius: 10)
    }
    
    func action() {
//        mapModel.goToUserLocation = true
//        
//        // This has to run after the button action ends (after the map view catches the signal)
//        DispatchQueue.main.async {
//            mapModel.goToUserLocation = false
//        }
    }
}
