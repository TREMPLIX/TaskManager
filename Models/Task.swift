import Foundation

// MARK: - Enums
enum Priority: Int, Codable, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    
    var displayValue: String {
        switch self {
        case .low: return "Низкий"
        case .medium: return "Средний"
        case .high: return "Высокий"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "#4CAF50"
        case .medium: return "#FFC107"
        case .high: return "#F44336"
        }
    }
}

enum Weekday: Int, Codable, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var shortName: String {
        switch self {
        case .sunday: return "Вс"
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        }
    }
}

// MARK: - Recurrence Models
struct RecurrenceRule: Codable {
    var frequency: Frequency
    var interval: Int
    var endCondition: EndCondition
    var weekdays: [Weekday]?
    var monthDay: Int?
    var monthWeekday: MonthWeekday? // Added missing property
    
    struct MonthWeekday: Codable {
        var week: Int
        var weekday: Weekday
    }
    
    enum Frequency: String, Codable {
        case daily, weekly, monthly, yearly
    }
    
    enum EndCondition: Codable {
        case never
        case endDate(Date)
        case occurrenceCount(Int)
        
        private enum CodingKeys: String, CodingKey {
            case type
            case endDate
            case occurrenceCount
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            switch type {
            case "never":
                self = .never
            case "endDate":
                let date = try container.decode(Date.self, forKey: .endDate)
                self = .endDate(date)
            case "occurrenceCount":
                let count = try container.decode(Int.self, forKey: .occurrenceCount)
                self = .occurrenceCount(count)
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid end condition type")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .never:
                try container.encode("never", forKey: .type)
            case .endDate(let date):
                try container.encode("endDate", forKey: .type)
                try container.encode(date, forKey: .endDate)
            case .occurrenceCount(let count):
                try container.encode("occurrenceCount", forKey: .type)
                try container.encode(count, forKey: .occurrenceCount)
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case frequency
        case interval
        case endCondition
        case weekdays
        case monthDay
        case monthWeekday
    }
    
    // Предустановленные правила
    static let everyDay = RecurrenceRule(
        frequency: .daily,
        interval: 1,
        endCondition: .never
    )
    
    static let everyWeekday = RecurrenceRule(
        frequency: .weekly,
        interval: 1,
        endCondition: .never,
        weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday]
    )
    
    // Валидация правила
    func validate() -> Bool {
        guard interval > 0 else { return false }
        
        switch frequency {
        case .monthly where monthDay != nil:
            return (1...31).contains(monthDay!)
        case .monthly where monthWeekday != nil:
            return (1...5).contains(monthWeekday!.week)
        case .yearly where monthDay != nil:
            return (1...366).contains(monthDay!)
        default:
            return true
        }
    }
    
    // Генерация следующих дат
    func nextOccurrences(startingFrom date: Date, count: Int = 10) -> [Date] {
        var result = [Date]()
        var currentDate = date
        var occurrences = 0
        
        while result.count < count {
            guard let nextDate = nextOccurrence(after: currentDate) else { break }
            
            switch endCondition {
            case .endDate(let endDate) where nextDate > endDate:
                return result
            case .occurrenceCount(let max) where occurrences >= max:
                return result
            default:
                break
            }
            
            result.append(nextDate)
            currentDate = nextDate
            occurrences += 1
        }
        
        return result
    }
    
    func nextOccurrence(after date: Date) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        
        switch frequency {
        case .daily:
            components.day = interval
        case .weekly:
            components.weekOfYear = interval
            if let weekdays = weekdays {
                let currentWeekday = Weekday(rawValue: calendar.component(.weekday, from: date))!
                guard let nextWeekday = (weekdays.sorted { $0.rawValue < $1.rawValue }
                    .first { $0.rawValue > currentWeekday.rawValue } ?? weekdays.first) else {
                    return nil
                }
                components.weekday = nextWeekday.rawValue
            }
        case .monthly:
            components.month = interval
            if let monthDay = monthDay {
                components.day = monthDay
            } else if let monthWeekday = monthWeekday {
                components.weekdayOrdinal = monthWeekday.week
                components.weekday = monthWeekday.weekday.rawValue
            }
        case .yearly:
            components.year = interval
            if let monthDay = monthDay {
                components.day = monthDay
            }
        }
        
        return calendar.date(byAdding: components, to: date, wrappingComponents: true)
    }
}

// MARK: - Main Task Model
struct Task: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String?
    var dueDate: Date?
    var startDate: Date?
    var endDate: Date?
    var isCompleted: Bool
    var status: TaskStatus
    var tags: [String]
    var priority: Priority
    var listId: UUID?
    var parentTaskId: UUID?
    var subtasks: [UUID]
    var recurrenceRule: RecurrenceRule?
    var excludedDates: [Date]
    var originalTaskId: UUID?
    var reminderDates: [Date]
    var isDeleted: Bool
    var deletedAt: Date?
    var createdAt: Date
    var updatedAt: Date
    var completedAt: Date?
    var estimatedDuration: TimeInterval?
    var actualDuration: TimeInterval?
    var attachments: [URL]
    var comments: [Comment]
    
    struct Comment: Codable, Identifiable {
        var id: UUID
        var userId: UUID
        var text: String
        var createdAt: Date
        var updatedAt: Date
        var isEdited: Bool
        
        init(id: UUID = UUID(),
             userId: UUID,
             text: String,
             createdAt: Date = Date(),
             updatedAt: Date = Date(),
             isEdited: Bool = false) {
            self.id = id
            self.userId = userId
            self.text = text
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.isEdited = isEdited
        }
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        dueDate: Date = Date(),
        startDate: Date? = nil,
        endDate: Date? = nil,
        isCompleted: Bool = false,
        status: TaskStatus = .notStarted,
        tags: [String] = [],
        priority: Priority = .medium,
        listId: UUID? = nil,
        parentTaskId: UUID? = nil,
        subtasks: [UUID] = [],
        recurrenceRule: RecurrenceRule? = nil,
        excludedDates: [Date] = [],
        reminderDates: [Date] = [],
        estimatedDuration: TimeInterval? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.startDate = startDate
        self.endDate = endDate
        self.isCompleted = isCompleted
        self.status = status
        self.tags = tags
        self.priority = priority
        self.listId = listId
        self.parentTaskId = parentTaskId
        self.subtasks = subtasks
        self.recurrenceRule = recurrenceRule
        self.excludedDates = excludedDates
        self.originalTaskId = nil
        self.reminderDates = reminderDates
        self.isDeleted = false
        self.deletedAt = nil
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.completedAt = nil
        self.estimatedDuration = estimatedDuration
        self.actualDuration = nil
        self.attachments = []
        self.comments = []
    }
    
    // MARK: - Computed Properties
    var isRecurring: Bool {
        recurrenceRule != nil
    }
    
    var isSubtask: Bool {
        parentTaskId != nil
    }
    
    var hasSubtasks: Bool {
        !subtasks.isEmpty
    }
    
    var duration: TimeInterval? {
        guard let start = startDate, let end = endDate else { return nil }
        return end.timeIntervalSince(start)
    }
    
    // MARK: - Methods
    func nextRecurrence() -> Task? {
        guard let rule = recurrenceRule,
              let dueDate = self.dueDate,
              let nextDate = rule.nextOccurrence(after: dueDate),
              !excludedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: nextDate) }) else {
            return nil
        }

        var newTask = self
        newTask.id = UUID()
        newTask.dueDate = nextDate

        if let start = startDate, let oldDue = self.dueDate {
            newTask.startDate = start.addingTimeInterval(nextDate.timeIntervalSince(oldDue))
        }

        if let end = endDate, let oldDue = self.dueDate {
            newTask.endDate = end.addingTimeInterval(nextDate.timeIntervalSince(oldDue))
        }

        newTask.isCompleted = false
        newTask.status = .notStarted
        newTask.originalTaskId = self.originalTaskId ?? self.id
        return newTask
    }

    mutating func addSubtask(_ taskId: UUID) {
        subtasks.append(taskId)
        updatedAt = Date()
    }
    
    mutating func removeSubtask(_ taskId: UUID) {
        subtasks.removeAll { $0 == taskId }
        updatedAt = Date()
    }
    
    mutating func complete(withActualDuration duration: TimeInterval? = nil) {
        isCompleted = true
        status = .completed
        completedAt = Date()
        actualDuration = duration
        updatedAt = Date()
    }
    
    mutating func updateStatus(_ newStatus: TaskStatus) {
        status = newStatus
        updatedAt = Date()
        
        if newStatus == .completed {
            complete()
        }
    }
    
    mutating func addReminder(at date: Date) {
        reminderDates.append(date)
        updatedAt = Date()
    }
    
    mutating func excludeDate(_ date: Date) {
        excludedDates.append(date)
        updatedAt = Date()
    }
    
    mutating func addAttachment(_ url: URL) {
        attachments.append(url)
        updatedAt = Date()
    }
    
    mutating func addComment(_ comment: Comment) {
        comments.append(comment)
        updatedAt = Date()
    }
    
    mutating func updateComment(_ commentId: UUID, newText: String) {
        if let index = comments.firstIndex(where: { $0.id == commentId }) {
            comments[index].text = newText
            comments[index].updatedAt = Date()
            comments[index].isEdited = true
            updatedAt = Date()
        }
    }
}

// MARK: - Extensions
extension Int {
    func pluralForm(_ one: String, _ few: String, _ many: String) -> String {
        let mod10 = self % 10
        let mod100 = self % 100
        
        if mod10 == 1 && mod100 != 11 {
            return one
        } else if (2...4).contains(mod10) && !(12...14).contains(mod100) {
            return few
        } else {
            return many
        }
    }
}
