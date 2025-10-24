import SwiftUI


struct ButtonDisplayMenu: View {
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


struct ToggleScreenOn: View {
    @EnvironmentObject var status: Status
    var body: some View {
        Toggle(isOn: $status.screenOn, label: {
            Label("Screen remains on", systemImage: status.screenOn ? "lock.open.display" : "lock.display")
                .foregroundColor(status.screenOn ? .red : .black)
        })
            .padding()
            .onChange(of: status.screenOn) {
                UIApplication.shared.isIdleTimerDisabled = status.screenOn
                // A test indicates that,
                // if the app has set the screen to remain on,
                // and if the app then moves to the background,
                // then the screen goes off with the normal delay.
                // Once the app gets moved to the foreground again,
                // its setting for keeping the screen on takes effect again.
            }
    }
}
