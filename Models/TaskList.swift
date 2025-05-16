import Foundation

enum TaskSortType: String, Codable, CaseIterable {
    case manual = "Вручную"
    case byDueDate = "По дате"
    case byPriority = "По приоритету"
    case byCreationDate = "По созданию"
    case byTitle = "По названию"
    case byDuration = "По длительности"
}

enum TaskGroupingType: String, Codable, CaseIterable {
    case none = "Без группировки"
    case byPriority = "По приоритету"
    case byDueDate = "По дате"
    case byTag = "По тегам"
    case byStatus = "По статусу"
    case byResponsible = "По исполнителю"
    case byCategory = "По категории"
}

enum ListDisplayMode: String, Codable, CaseIterable {
    case list = "Список"
    case kanban = "Канбан"
    case calendar = "Календарь"
    case timeline = "Таймлайн"
}

struct KanbanColumn: Identifiable, Codable {
    let id: UUID
    var title: String
    var status: TaskStatus
    var taskIds: [UUID]
    var noteIds: [UUID]
    var color: String
    var order: Int
    var limit: Int?

    init(
        id: UUID = UUID(),
        title: String,
        status: TaskStatus,
        taskIds: [UUID] = [],
        noteIds: [UUID] = [],
        color: String = "#FFFFFF",
        order: Int,
        limit: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.status = status
        self.taskIds = taskIds
        self.noteIds = noteIds
        self.color = color
        self.order = order
        self.limit = limit
    }
}

struct TaskList: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var userId: UUID
    var tasks: [UUID]
    var notes: [UUID]
    var taskOrder: [UUID]?
    var noteOrder: [UUID]?
    var sortType: TaskSortType
    var isAscending: Bool
    var groupingType: TaskGroupingType
    var displayMode: ListDisplayMode
    var kanbanColumns: [KanbanColumn]
    var colorTheme: String
    var iconName: String
    var isShared: Bool
    var sharedWith: [UUID]
    var isArchived: Bool
    var isFavorite: Bool
    var categories: [UUID]
    var parentListId: UUID?
    var subLists: [UUID]
    var isDeleted: Bool
    var deletedAt: Date?
    var notificationSettings: NotificationSettings
    let createdAt: Date
    var updatedAt: Date
    var colorHex: String?

    struct NotificationSettings: Codable {
        var enableDueDateReminders: Bool
        var reminderTimeBeforeDue: TimeInterval
        var enableStatusChangeNotifications: Bool
        var enableSharingNotifications: Bool
    }

    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        userId: UUID,
        tasks: [UUID] = [],
        notes: [UUID] = [],
        taskOrder: [UUID]? = nil,
        noteOrder: [UUID]? = nil,
        sortType: TaskSortType = .manual,
        isAscending: Bool = true,
        groupingType: TaskGroupingType = .none,
        displayMode: ListDisplayMode = .list,
        kanbanColumns: [KanbanColumn] = [
            KanbanColumn(title: "Не начата", status: TaskStatus.notStarted, color: "#FFCDD2", order: 1),
            KanbanColumn(title: "В процессе", status: TaskStatus.inProgress, color: "#BBDEFB", order: 2),
            KanbanColumn(title: "Завершена", status: TaskStatus.completed, color: "#C8E6C9", order: 3)
        ],
        colorTheme: String = "#FFFFFF",
        iconName: String = "list.bullet",
        isShared: Bool = false,
        sharedWith: [UUID] = [],
        isArchived: Bool = false,
        isFavorite: Bool = false,
        categories: [UUID] = [],
        parentListId: UUID? = nil,
        subLists: [UUID] = [],
        isDeleted: Bool = false,
        deletedAt: Date? = nil,
        notificationSettings: NotificationSettings = .init(
            enableDueDateReminders: true,
            reminderTimeBeforeDue: 15 * 60,
            enableStatusChangeNotifications: false,
            enableSharingNotifications: false
        ),
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.userId = userId
        self.tasks = tasks
        self.notes = notes
        self.taskOrder = taskOrder
        self.noteOrder = noteOrder
        self.sortType = sortType
        self.isAscending = isAscending
        self.groupingType = groupingType
        self.displayMode = displayMode
        self.kanbanColumns = kanbanColumns
        self.colorTheme = colorTheme
        self.iconName = iconName
        self.isShared = isShared
        self.sharedWith = sharedWith
        self.isArchived = isArchived
        self.isFavorite = isFavorite
        self.categories = categories
        self.parentListId = parentListId
        self.subLists = subLists
        self.isDeleted = isDeleted
        self.deletedAt = deletedAt
        self.notificationSettings = notificationSettings
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    mutating func addTask(_ taskId: UUID) {
        tasks.append(taskId)
        taskOrder?.append(taskId)
        updatedAt = Date()
    }

    mutating func addNote(_ noteId: UUID) {
        notes.append(noteId)
        noteOrder?.append(noteId)
        updatedAt = Date()
    }

    mutating func removeTask(_ taskId: UUID) {
        tasks.removeAll { $0 == taskId }
        taskOrder?.removeAll { $0 == taskId }
        for index in kanbanColumns.indices {
            kanbanColumns[index].taskIds.removeAll { $0 == taskId }
        }
        updatedAt = Date()
    }

    mutating func removeNote(_ noteId: UUID) {
        notes.removeAll { $0 == noteId }
        noteOrder?.removeAll { $0 == noteId }
        for index in kanbanColumns.indices {
            kanbanColumns[index].noteIds.removeAll { $0 == noteId }
        }
        updatedAt = Date()
    }

    mutating func delete() {
        isDeleted = true
        deletedAt = Date()
        updatedAt = Date()
    }

    mutating func restore() {
        isDeleted = false
        deletedAt = nil
        updatedAt = Date()
    }
}
