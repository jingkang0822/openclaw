import Foundation
import Testing
@testable import ClawX

@Suite struct GatewayLaunchAgentManagerTests {
    @Test func launchAgentPlistSnapshotParsesArgsAndEnv() throws {
        let url = FileManager().temporaryDirectory
            .appendingPathComponent("clawx-launchd-\(UUID().uuidString).plist")
        let plist: [String: Any] = [
            "ProgramArguments": ["clawx", "gateway-daemon", "--port", "19789", "--bind", "loopback"],
            "EnvironmentVariables": [
                "CLAWX_GATEWAY_TOKEN": " secret ",
                "CLAWX_GATEWAY_PASSWORD": "pw",
            ],
        ]
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try data.write(to: url, options: [.atomic])
        defer { try? FileManager().removeItem(at: url) }

        let snapshot = try #require(LaunchAgentPlist.snapshot(url: url))
        #expect(snapshot.port == 19789)
        #expect(snapshot.bind == "loopback")
        #expect(snapshot.token == "secret")
        #expect(snapshot.password == "pw")
    }

    @Test func launchAgentPlistSnapshotAllowsMissingBind() throws {
        let url = FileManager().temporaryDirectory
            .appendingPathComponent("clawx-launchd-\(UUID().uuidString).plist")
        let plist: [String: Any] = [
            "ProgramArguments": ["clawx", "gateway-daemon", "--port", "19789"],
        ]
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try data.write(to: url, options: [.atomic])
        defer { try? FileManager().removeItem(at: url) }

        let snapshot = try #require(LaunchAgentPlist.snapshot(url: url))
        #expect(snapshot.port == 19789)
        #expect(snapshot.bind == nil)
    }
}
