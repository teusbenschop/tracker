import SwiftUI


struct ButtonDisplayMenu: View {
    @EnvironmentObject var status: Status
    var body: some View {
        Button(action: {status.showMenu = true}) {
            Image(systemName: "text.aligncenter")
                .fontWeight(.medium)
                .frame(width: 40, height: 40)

        }
        .buttonStyle(.borderedProminent)
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


struct ToggleFollowUserLocation: View {
    @EnvironmentObject var status: Status
    var body: some View {
        Toggle(isOn: $status.followingLocation, label: {
            Label("Map follows your location", systemImage: status.followingLocation ? "location.fill" : "location.slash")
        })
        .padding()
        .onChange(of: status.userTrackingMode) {
        }
    }
}


struct ToggleFollowUserDirection: View {
    @EnvironmentObject var status: Status
    var body: some View {
        Toggle(isOn: $status.followingDirection, label: {
            Label("Map follows your direction", systemImage: status.followingDirection ? "location.north.line.fill" : "location.slash")
        })
        .padding()
        .onChange(of: status.userTrackingMode) {
        }
    }
}


struct TextLocationInfo: View {
    @EnvironmentObject var locationModel: LocationManager
    var body: some View {
        Text(locationModel.info)
            .font(.system(size: 12, weight: .thin))
            .multilineTextAlignment(.center)
    }
}


extension Bundle {
    public var appBuild: String          { getInfo("CFBundleVersion") }
    public var appVersionLong: String    { getInfo("CFBundleShortVersionString") }
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}


struct TextAboutApp: View {
    @EnvironmentObject var locationModel: LocationManager
    var body: some View {
        Text("Flyering version \(Bundle.main.appVersionLong)")
            .font(.system(size: 12, weight: .thin))
            .multilineTextAlignment(.center)
    }
}
