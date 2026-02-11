import Foundation

public enum ClawXChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(ClawXChatEventPayload)
    case agent(ClawXAgentEventPayload)
    case seqGap
}

public protocol ClawXChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> ClawXChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [ClawXChatAttachmentPayload]) async throws -> ClawXChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> ClawXChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<ClawXChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension ClawXChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "ClawXChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> ClawXChatSessionsListResponse {
        throw NSError(
            domain: "ClawXChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
