import AppKit
import SwiftUI

@main
struct M3TurboSwitchApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        MenuBarExtra {
            Button {
                state.refreshMenuData()
            } label: {
                Text("Current temp: \(state.currentTemperatureText)")
            }
            .disabled(true)

            Divider()

            Button(state.turboEnabled ? "Disable Turbo Boost" : "Enable Turbo Boost") {
                state.toggleTurbo()
            }

            Toggle("Open at Login", isOn: Binding(
                get: { state.openAtLogin },
                set: { newValue in
                    state.openAtLogin = newValue
                    state.setOpenAtLogin(newValue)
                }
            ))

            Toggle("Disable Turbo Boost on Boot", isOn: Binding(
                get: { state.disableTurboOnBoot },
                set: { newValue in
                    state.disableTurboOnBoot = newValue
                    state.setDisableTurboOnBoot(newValue)
                }
            ))

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: state.turboEnabled ? "bolt.fill" : "bolt.slash.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
