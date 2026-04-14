import Foundation

protocol TemperatureMonitorProtocol {
    func currentCPUTemperatureText() -> String
}

final class TemperatureMonitor: TemperatureMonitorProtocol {
    func currentCPUTemperatureText() -> String {
        // Placeholder implementation.
        // Replace with SMC / powermetrics reader and parse one current CPU temp value.
        return "-- °C"
    }
}
