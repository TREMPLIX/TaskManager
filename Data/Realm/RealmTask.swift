import Foundation
import RealmSwift

final class RealmTask: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var taskDescription: String?
    @Persisted var dueDate: Date
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var isCompleted: Bool
    @Persisted var statusRaw: String
    @Persisted var tags: List<String>
    @Persisted var priorityRaw: Int
    @Persisted var listId: String?
    @Persisted var parentTaskId: String?
    @Persisted var subtaskIds: List<String>
    @Persisted var recurrenceRuleData: Data?
    @Persisted var excludedDates: List<Date>
    @Persisted var originalTaskId: String?
    @Persisted var reminderDates: List<Date>
    @Persisted var isDeleted: Bool
    @Persisted var deletedAt: Date?
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var completedAt: Date?
    @Persisted var estimatedDuration: Double?
    @Persisted var actualDuration: Double?
    @Persisted var attachmentURLs: List<String>
    @Persisted var commentsData: Data?

    convenience init(from task: Task) {
        self.init()
        self.id = task.id.uuidString
        self.title = task.title
        self.taskDescription = task.description
        self.dueDate = task.dueDate ?? Date()
        self.startDate = task.startDate
        self.endDate = task.endDate
        self.isCompleted = task.isCompleted
        self.statusRaw = task.status.rawValue

        // Разбиваем массивы на отдельные выражения
        let tagsCopy = task.tags
        self.tags.append(objectsIn: tagsCopy)

        self.priorityRaw = task.priority.rawValue
        self.listId = task.listId?.uuidString
        self.parentTaskId = task.parentTaskId?.uuidString

        let subtaskStrings = task.subtasks.map { $0.uuidString }
        self.subtaskIds.append(objectsIn: subtaskStrings)

        if let recurrenceRule = task.recurrenceRule {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(recurrenceRule) {
                self.recurrenceRuleData = data
            }
        }

        let excludedDatesCopy = task.excludedDates
        self.excludedDates.append(objectsIn: excludedDatesCopy)

        self.originalTaskId = task.originalTaskId?.uuidString

        let remindersCopy = task.reminderDates
        self.reminderDates.append(objectsIn: remindersCopy)

        self.isDeleted = task.isDeleted
        self.deletedAt = task.deletedAt
        self.createdAt = task.createdAt
        self.updatedAt = task.updatedAt
        self.completedAt = task.completedAt
        self.estimatedDuration = task.estimatedDuration
        self.actualDuration = task.actualDuration

        let urlsCopy = task.attachments.map { $0.absoluteString }
        self.attachmentURLs.append(objectsIn: urlsCopy)

        // 🧨 Вот здесь разбиваем жёстко
        let commentEncoder = JSONEncoder()
        let commentsToEncode: [Task.Comment] = task.comments
        do {
            let encodedComments = try commentEncoder.encode(commentsToEncode)
            self.commentsData = encodedComments
        } catch {
            self.commentsData = nil
            print("Failed to encode comments: \(error)")
        }

    }


    func toStruct() -> Task {
        var task = Task(
            id: UUID(uuidString: id)!,
            title: title,
            description: taskDescription,
            dueDate: dueDate,
            startDate: startDate,
            endDate: endDate,
            isCompleted: isCompleted,
            status: TaskStatus(rawValue: statusRaw) ?? .notStarted,
            tags: Array(tags),
            priority: Priority(rawValue: priorityRaw) ?? .medium,
            listId: listId != nil ? UUID(uuidString: listId!) : nil,
            parentTaskId: parentTaskId != nil ? UUID(uuidString: parentTaskId!) : nil,
            subtasks: subtaskIds.compactMap { UUID(uuidString: $0) },
            recurrenceRule: recurrenceRuleData.flatMap { try? JSONDecoder().decode(RecurrenceRule.self, from: $0) },
            excludedDates: Array(excludedDates),
            reminderDates: Array(reminderDates),
            estimatedDuration: estimatedDuration,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        
        task.originalTaskId = originalTaskId.flatMap(UUID.init(uuidString:))
        task.isDeleted = isDeleted
        task.deletedAt = deletedAt
        task.completedAt = completedAt
        task.actualDuration = actualDuration
        task.attachments = attachmentURLs.compactMap { URL(string: $0) }
        let decoder = JSONDecoder()
        var decodedComments: [Task.Comment] = []

        if let data = commentsData {
            if let result = try? decoder.decode([Task.Comment].self, from: data) {
                decodedComments = result
            }
        }

        task.comments = decodedComments


        return task
    }

}

private extension Task {
    mutating func then(_ update: (inout Task) -> Void) -> Task {
        update(&self)
        return self
    }
}
