import SwiftUI

struct ButtonMenu: View {
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
}


struct ButtonCenterMapOnUser: View {
    @EnvironmentObject var status: Status
    var body: some View {
        Button(action: {
            status.goToUserLocation = true
            // This has to run after the button action ends (after the map view catches the signal)
            DispatchQueue.main.async {
                status.goToUserLocation = false
            }
            status.showMenu = false
        })
        {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text("Center map on your position")
                Image(systemName: "person")
            }
        }
        .padding()
        .buttonStyle(.bordered)
    }
}
