import Foundation

public enum ClawXRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum ClawXReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct ClawXRemindersListParams: Codable, Sendable, Equatable {
    public var status: ClawXReminderStatusFilter?
    public var limit: Int?

    public init(status: ClawXReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct ClawXRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct ClawXReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct ClawXRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [ClawXReminderPayload]

    public init(reminders: [ClawXReminderPayload]) {
        self.reminders = reminders
    }
}

public struct ClawXRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: ClawXReminderPayload

    public init(reminder: ClawXReminderPayload) {
        self.reminder = reminder
    }
}
