import Foundation
import RealmSwift

class RealmTaskList: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var title: String
    @Persisted var colorHex: String?
    @Persisted var isArchived: Bool
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date


    convenience init(from list: TaskList) {
        self.init()
        id = list.id.uuidString
        userId = list.userId.uuidString
        title = list.title
        isArchived = list.isArchived
        createdAt = list.createdAt
        updatedAt = list.updatedAt

    }

    func toStruct() -> TaskList {
        return TaskList(
            id: UUID(uuidString: id)!,
            title: title,
            userId: UUID(uuidString: userId)!,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,

        )
    }
}
