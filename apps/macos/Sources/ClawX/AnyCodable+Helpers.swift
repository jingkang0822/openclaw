import ClawXKit
import ClawXProtocol
import Foundation

// Prefer the ClawXKit wrapper to keep gateway request payloads consistent.
typealias AnyCodable = ClawXKit.AnyCodable
typealias InstanceIdentity = ClawXKit.InstanceIdentity

extension AnyCodable {
    var stringValue: String? { self.value as? String }
    var boolValue: Bool? { self.value as? Bool }
    var intValue: Int? { self.value as? Int }
    var doubleValue: Double? { self.value as? Double }
    var dictionaryValue: [String: AnyCodable]? { self.value as? [String: AnyCodable] }
    var arrayValue: [AnyCodable]? { self.value as? [AnyCodable] }

    var foundationValue: Any {
        switch self.value {
        case let dict as [String: AnyCodable]:
            dict.mapValues { $0.foundationValue }
        case let array as [AnyCodable]:
            array.map(\.foundationValue)
        default:
            self.value
        }
    }
}

extension ClawXProtocol.AnyCodable {
    var stringValue: String? { self.value as? String }
    var boolValue: Bool? { self.value as? Bool }
    var intValue: Int? { self.value as? Int }
    var doubleValue: Double? { self.value as? Double }
    var dictionaryValue: [String: ClawXProtocol.AnyCodable]? { self.value as? [String: ClawXProtocol.AnyCodable] }
    var arrayValue: [ClawXProtocol.AnyCodable]? { self.value as? [ClawXProtocol.AnyCodable] }

    var foundationValue: Any {
        switch self.value {
        case let dict as [String: ClawXProtocol.AnyCodable]:
            dict.mapValues { $0.foundationValue }
        case let array as [ClawXProtocol.AnyCodable]:
            array.map(\.foundationValue)
        default:
            self.value
        }
    }
}
