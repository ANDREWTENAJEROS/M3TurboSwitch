import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var turboEnabled: Bool = true
    @Published var currentTemperatureText: String = "-- °C"
    @Published var openAtLogin: Bool
    @Published var disableTurboOnBoot: Bool

    private let preferences = PreferencesStore()
    private let turboController: TurboControllerProtocol = TurboController()
    private let temperatureMonitor: TemperatureMonitorProtocol = TemperatureMonitor()
    private let loginItemManager: LoginItemManagerProtocol = LoginItemManager()

    init() {
        self.openAtLogin = preferences.openAtLogin
        self.disableTurboOnBoot = preferences.disableTurboOnBoot

        turboEnabled = turboController.readTurboStatus()

        if disableTurboOnBoot {
            turboController.setTurbo(enabled: false)
            turboEnabled = false
        }
    }

    func refreshMenuData() {
        turboEnabled = turboController.readTurboStatus()
        currentTemperatureText = temperatureMonitor.currentCPUTemperatureText()
    }

    func toggleTurbo() {
        let newValue = !turboEnabled
        let ok = turboController.setTurbo(enabled: newValue)
        if ok {
            turboEnabled = newValue
        }
    }

    func setOpenAtLogin(_ enabled: Bool) {
        preferences.openAtLogin = enabled
        loginItemManager.setOpenAtLogin(enabled)
    }

    func setDisableTurboOnBoot(_ enabled: Bool) {
        preferences.disableTurboOnBoot = enabled
    }
}
