import Foundation
import RealmSwift

class RealmNote: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var listId: String?
    @Persisted var tags = List<String>()
    @Persisted var categories = List<String>() // UUID as string
    @Persisted var isPinned: Bool
    @Persisted var isArchived: Bool
    @Persisted var attachments = List<String>() // URLs as string
    @Persisted var location: RealmLocation?
    @Persisted var reminders = List<Date>()
    @Persisted var isCompleted: Bool
    @Persisted var isPrivate: Bool
    @Persisted var sharedWith = List<String>()
    @Persisted var encryptionKey: String?
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var createdBy: String?
    @Persisted var updatedBy: String?

    convenience init(from note: Note) {
        self.init()
        id = note.id.uuidString
        userId = note.userId.uuidString
        title = note.title
        content = note.content
        listId = note.listId?.uuidString
        tags.append(objectsIn: note.tags)
        categories.append(objectsIn: note.categories.map { $0.uuidString })
        isPinned = note.isPinned
        isArchived = note.isArchived
        attachments.append(objectsIn: note.attachments.map { $0.absoluteString })
        if let location = note.location {
            self.location = RealmLocation(from: location)
        }
        reminders.append(objectsIn: note.reminders)
        isCompleted = note.isCompleted
        isPrivate = note.isPrivate
        sharedWith.append(objectsIn: note.sharedWith.map { $0.uuidString })
        encryptionKey = note.encryptionKey
        createdAt = note.createdAt
        updatedAt = note.updatedAt
        createdBy = note.createdBy?.uuidString
        updatedBy = note.updatedBy?.uuidString
    }

    func toStruct() -> Note {
        return Note(
            id: UUID(uuidString: id)!,
            userId: UUID(uuidString: userId)!,
            title: title,
            content: content,
            listId: listId.flatMap(UUID.init),
            tags: Array(tags),
            categories: categories.compactMap(UUID.init),
            isPinned: isPinned,
            isArchived: isArchived,
            attachments: attachments.compactMap { URL(string: $0) },
            location: location?.toStruct(),
            reminders: Array(reminders),
            isCompleted: isCompleted,
            isPrivate: isPrivate,
            sharedWith: sharedWith.compactMap(UUID.init),
            encryptionKey: encryptionKey,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy.flatMap(UUID.init),
            updatedBy: updatedBy.flatMap(UUID.init)
        )
    }
}

class RealmLocation: EmbeddedObject {
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var name: String?

    convenience init(from location: Location) {
        self.init()
        latitude = location.latitude
        longitude = location.longitude
        name = location.name
    }

    func toStruct() -> Location {
        return Location(
            latitude: latitude,
            longitude: longitude,
            name: name
        )
    }
}
