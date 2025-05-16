import Foundation
import RealmSwift

final class TaskRepository {
    private let realm = try! Realm()

    func getTask(by id: UUID) -> Task? {
        guard let realmTask = realm.object(ofType: RealmTask.self, forPrimaryKey: id.uuidString) else { return nil }
        return realmTask.toStruct()
    }

    func getAllTasks() -> [Task] {
        return realm.objects(RealmTask.self).map { $0.toStruct() }
    }

    func addTask(_ task: Task) {
        let realmTask = RealmTask(from: task)
        try! realm.write {
            realm.add(realmTask, update: .modified)
        }
    }

    func updateTask(_ task: Task) {
        addTask(task)
    }

    func deleteTask(by id: UUID) {
        guard let object = realm.object(ofType: RealmTask.self, forPrimaryKey: id.uuidString) else { return }
        try! realm.write {
            realm.delete(object)
        }
    }

    func filterTasks(by userId: UUID, isCompleted: Bool? = nil) -> [Task] {
        var results = realm.objects(RealmTask.self).filter("userId == %@", userId.uuidString)
        if let completed = isCompleted {
            results = results.filter("isCompleted == %@", completed)
        }
        return results.map { $0.toStruct() }
    }

}
