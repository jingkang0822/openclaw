import Foundation
import Testing
@testable import ClawX

@Suite(.serialized)
struct ClawXConfigFileTests {
    @Test
    func configPathRespectsEnvOverride() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("clawx-config-\(UUID().uuidString)")
            .appendingPathComponent("clawx.json")
            .path

        await TestIsolation.withEnvValues(["CLAWX_CONFIG_PATH": override]) {
            #expect(ClawXConfigFile.url().path == override)
        }
    }

    @MainActor
    @Test
    func remoteGatewayPortParsesAndMatchesHost() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("clawx-config-\(UUID().uuidString)")
            .appendingPathComponent("clawx.json")
            .path

        await TestIsolation.withEnvValues(["CLAWX_CONFIG_PATH": override]) {
            ClawXConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "ws://gateway.ts.net:19999",
                    ],
                ],
            ])
            #expect(ClawXConfigFile.remoteGatewayPort() == 19999)
            #expect(ClawXConfigFile.remoteGatewayPort(matchingHost: "gateway.ts.net") == 19999)
            #expect(ClawXConfigFile.remoteGatewayPort(matchingHost: "gateway") == 19999)
            #expect(ClawXConfigFile.remoteGatewayPort(matchingHost: "other.ts.net") == nil)
        }
    }

    @MainActor
    @Test
    func setRemoteGatewayUrlPreservesScheme() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("clawx-config-\(UUID().uuidString)")
            .appendingPathComponent("clawx.json")
            .path

        await TestIsolation.withEnvValues(["CLAWX_CONFIG_PATH": override]) {
            ClawXConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                    ],
                ],
            ])
            ClawXConfigFile.setRemoteGatewayUrl(host: "new-host", port: 2222)
            let root = ClawXConfigFile.loadDict()
            let url = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any])?["url"] as? String
            #expect(url == "wss://new-host:2222")
        }
    }

    @Test
    func stateDirOverrideSetsConfigPath() async {
        let dir = FileManager().temporaryDirectory
            .appendingPathComponent("clawx-state-\(UUID().uuidString)", isDirectory: true)
            .path

        await TestIsolation.withEnvValues([
            "CLAWX_CONFIG_PATH": nil,
            "CLAWX_STATE_DIR": dir,
        ]) {
            #expect(ClawXConfigFile.stateDirURL().path == dir)
            #expect(ClawXConfigFile.url().path == "\(dir)/clawx.json")
        }
    }
}
