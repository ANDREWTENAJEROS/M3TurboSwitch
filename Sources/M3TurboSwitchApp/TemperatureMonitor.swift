import Foundation

protocol TemperatureMonitorProtocol {
    func currentCPUTemperatureText() -> String
}

final class TemperatureMonitor: TemperatureMonitorProtocol {
    func currentCPUTemperatureText() -> String {
        guard let output = runCommand("/usr/bin/powermetrics", args: ["-n", "1", "--samplers", "smc"]) else {
            return "N/A (placeholder)"
        }

        for line in output.split(separator: "\n") {
            let lower = line.lowercased()
            if lower.contains("cpu die temperature") || lower.contains("cpu temperature") {
                return line
                    .replacingOccurrences(of: "CPU die temperature:", with: "")
                    .replacingOccurrences(of: "CPU Temperature:", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
        }

        return "N/A (placeholder)"
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
