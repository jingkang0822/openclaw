import Foundation

public enum ClawXCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum ClawXCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum ClawXCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum ClawXCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct ClawXCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: ClawXCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: ClawXCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: ClawXCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: ClawXCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct ClawXCameraClipParams: Codable, Sendable, Equatable {
    public var facing: ClawXCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: ClawXCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: ClawXCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: ClawXCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
