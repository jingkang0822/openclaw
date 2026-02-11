import AppKit
import ClawXChatUI
import Foundation
import Testing
@testable import ClawX

@Suite(.serialized)
@MainActor
struct WebChatSwiftUISmokeTests {
    private struct TestTransport: ClawXChatTransport, Sendable {
        func requestHistory(sessionKey: String) async throws -> ClawXChatHistoryPayload {
            let json = """
            {"sessionKey":"\(sessionKey)","sessionId":null,"messages":[],"thinkingLevel":"off"}
            """
            return try JSONDecoder().decode(ClawXChatHistoryPayload.self, from: Data(json.utf8))
        }

        func sendMessage(
            sessionKey _: String,
            message _: String,
            thinking _: String,
            idempotencyKey _: String,
            attachments _: [ClawXChatAttachmentPayload]) async throws -> ClawXChatSendResponse
        {
            let json = """
            {"runId":"\(UUID().uuidString)","status":"ok"}
            """
            return try JSONDecoder().decode(ClawXChatSendResponse.self, from: Data(json.utf8))
        }

        func requestHealth(timeoutMs _: Int) async throws -> Bool { true }

        func events() -> AsyncStream<ClawXChatTransportEvent> {
            AsyncStream { continuation in
                continuation.finish()
            }
        }

        func setActiveSessionKey(_: String) async throws {}
    }

    @Test func windowControllerShowAndClose() {
        let controller = WebChatSwiftUIWindowController(
            sessionKey: "main",
            presentation: .window,
            transport: TestTransport())
        controller.show()
        controller.close()
    }

    @Test func panelControllerPresentAndClose() {
        let anchor = { NSRect(x: 200, y: 400, width: 40, height: 40) }
        let controller = WebChatSwiftUIWindowController(
            sessionKey: "main",
            presentation: .panel(anchorProvider: anchor),
            transport: TestTransport())
        controller.presentAnchored(anchorProvider: anchor)
        controller.close()
    }
}
