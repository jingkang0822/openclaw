import Foundation

public enum ClawXDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum ClawXBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum ClawXThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum ClawXNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum ClawXNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct ClawXBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: ClawXBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: ClawXBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct ClawXThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: ClawXThermalState

    public init(state: ClawXThermalState) {
        self.state = state
    }
}

public struct ClawXStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct ClawXNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: ClawXNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [ClawXNetworkInterfaceType]

    public init(
        status: ClawXNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [ClawXNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct ClawXDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: ClawXBatteryStatusPayload
    public var thermal: ClawXThermalStatusPayload
    public var storage: ClawXStorageStatusPayload
    public var network: ClawXNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: ClawXBatteryStatusPayload,
        thermal: ClawXThermalStatusPayload,
        storage: ClawXStorageStatusPayload,
        network: ClawXNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct ClawXDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
