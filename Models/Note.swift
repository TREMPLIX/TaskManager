import Foundation

struct Location: Codable {
  let latitude: Double
  let longitude: Double
  let name: String?
}

struct Note: Identifiable, Codable {
  let id: UUID
  let userId: UUID
  var title: String
  var content: String
  var listId: UUID?
  var tags: [String]
  var categories: [UUID]
  var isPinned: Bool
  var isArchived: Bool
  var attachments: [URL]
  var location: Location?
  var reminders: [Date]
  var isCompleted: Bool
  var isPrivate: Bool
  var sharedWith: [UUID]
  var encryptionKey: String?
  let createdAt: Date
  var updatedAt: Date
  let createdBy: UUID?
  let updatedBy: UUID?

  init(
    id: UUID = UUID(),
    userId: UUID,
    title: String,
    content: String,
    listId: UUID? = nil,
    tags: [String] = [],
    categories: [UUID] = [],
    isPinned: Bool = false,
    isArchived: Bool = false,
    attachments: [URL] = [],
    location: Location? = nil,
    reminders: [Date] = [],
    isCompleted: Bool = false,
    isPrivate: Bool = false,
    sharedWith: [UUID] = [],
    encryptionKey: String? = nil,
    createdAt: Date = Date(),
    updatedAt: Date = Date(),
    createdBy: UUID? = nil,
    updatedBy: UUID? = nil
  ) {
    self.id = id
    self.userId = userId
    self.title = title
    self.content = content
    self.listId = listId
    self.tags = tags
    self.categories = categories
    self.isPinned = isPinned
    self.isArchived = isArchived
    self.attachments = attachments
    self.location = location
    self.reminders = reminders
    self.isCompleted = isCompleted
    self.isPrivate = isPrivate
    self.sharedWith = sharedWith
    self.encryptionKey = encryptionKey
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.createdBy = createdBy
    self.updatedBy = updatedBy
  }
}
