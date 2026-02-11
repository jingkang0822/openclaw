import CoreLocation
import Foundation
import ClawXKit
import UIKit

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: ClawXCameraSnapParams) async throws -> (format: String, base64: String, width: Int, height: Int)
    func clip(params: ClawXCameraClipParams) async throws -> (format: String, base64: String, durationMs: Int, hasAudio: Bool)
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: ClawXLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: ClawXLocationGetParams,
        desiredAccuracy: ClawXLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> ClawXDeviceStatusPayload
    func info() -> ClawXDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: ClawXPhotosLatestParams) async throws -> ClawXPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: ClawXContactsSearchParams) async throws -> ClawXContactsSearchPayload
    func add(params: ClawXContactsAddParams) async throws -> ClawXContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: ClawXCalendarEventsParams) async throws -> ClawXCalendarEventsPayload
    func add(params: ClawXCalendarAddParams) async throws -> ClawXCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: ClawXRemindersListParams) async throws -> ClawXRemindersListPayload
    func add(params: ClawXRemindersAddParams) async throws -> ClawXRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: ClawXMotionActivityParams) async throws -> ClawXMotionActivityPayload
    func pedometer(params: ClawXPedometerParams) async throws -> ClawXPedometerPayload
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
