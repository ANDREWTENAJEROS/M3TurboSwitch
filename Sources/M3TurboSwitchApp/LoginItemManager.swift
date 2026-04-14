import Foundation
import ServiceManagement

protocol LoginItemManagerProtocol {
    func setOpenAtLogin(_ enabled: Bool)
}

final class LoginItemManager: LoginItemManagerProtocol {
    func setOpenAtLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                // Keep app simple: ignore and let UI state persist;
                // production code should surface this to users.
            }
        }
    }
}
