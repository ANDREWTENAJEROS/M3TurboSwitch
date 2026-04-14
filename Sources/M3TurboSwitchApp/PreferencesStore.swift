import Foundation

final class PreferencesStore {
    private enum Keys {
        static let openAtLogin = "openAtLogin"
        static let disableTurboOnBoot = "disableTurboOnBoot"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var openAtLogin: Bool {
        get { defaults.bool(forKey: Keys.openAtLogin) }
        set { defaults.set(newValue, forKey: Keys.openAtLogin) }
    }

    var disableTurboOnBoot: Bool {
        get { defaults.bool(forKey: Keys.disableTurboOnBoot) }
        set { defaults.set(newValue, forKey: Keys.disableTurboOnBoot) }
    }
}
