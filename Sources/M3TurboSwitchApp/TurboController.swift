import Foundation

protocol TurboControllerProtocol {
    func readTurboStatus() -> Bool
    @discardableResult
    func setTurbo(enabled: Bool) -> Bool
}

final class TurboController: TurboControllerProtocol {
    private let kextBundleIdentifier = "com.rugarciap.DisableTurboBoost"
    private let candidateKextPaths = [
        "/Applications/Turbo Boost Switcher.app/Contents/Resources/DisableTurboBoost.kext",
        "/Library/Extensions/DisableTurboBoost.kext"
    ]

    func readTurboStatus() -> Bool {
        // Turbo is considered disabled when DisableTurboBoost.kext is loaded.
        !isDisableTurboKextLoaded()
    }

    @discardableResult
    func setTurbo(enabled: Bool) -> Bool {
        guard let kextPath = findInstalledKextPath() else {
            return false
        }

        let command = enabled ? unloadCommand(kextPath: kextPath) : loadCommand(kextPath: kextPath)
        guard runPrivileged(command: command) else {
            return false
        }

        return readTurboStatus() == enabled
    }

    private func isDisableTurboKextLoaded() -> Bool {
        if let kextstat = runCommand("/usr/sbin/kextstat", args: []),
           kextstat.localizedCaseInsensitiveContains(kextBundleIdentifier) {
            return true
        }

        if let kmutil = runCommand("/usr/bin/kmutil", args: ["showloaded"]),
           kmutil.localizedCaseInsensitiveContains("DisableTurboBoost") {
            return true
        }

        return false
    }

    private func findInstalledKextPath() -> String? {
        for path in candidateKextPaths where FileManager.default.fileExists(atPath: path) {
            return path
        }
        return nil
    }

    private func loadCommand(kextPath: String) -> String {
        if FileManager.default.fileExists(atPath: "/usr/bin/kmutil") {
            return "/usr/bin/kmutil load -p \"\(kextPath)\""
        }
        return "/sbin/kextload \"\(kextPath)\""
    }

    private func unloadCommand(kextPath: String) -> String {
        if FileManager.default.fileExists(atPath: "/usr/bin/kmutil") {
            return "/usr/bin/kmutil unload -b \"\(kextBundleIdentifier)\" || /usr/bin/kmutil unload -p \"\(kextPath)\""
        }
        return "/sbin/kextunload \"\(kextPath)\""
    }

    private func runPrivileged(command: String) -> Bool {
        let escaped = command.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")

        let script = "do shell script \"\(escaped)\" with administrator privileges"
        guard let output = runCommand("/usr/bin/osascript", args: ["-e", script]) else {
            return false
        }

        return !output.localizedCaseInsensitiveContains("error")
    }

    private func runCommand(_ launchPath: String, args: [String]) -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: launchPath)
        process.arguments = args

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
