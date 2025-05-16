import Foundation
import RealmSwift

final class TaskListRepository {
    private let realm = try! Realm()

    func getList(by id: UUID) -> TaskList? {
        guard let object = realm.object(ofType: RealmTaskList.self, forPrimaryKey: id.uuidString) else { return nil }
        return object.toStruct()
    }

    func getAllLists() -> [TaskList] {
        return realm.objects(RealmTaskList.self).map { $0.toStruct() }
    }

    func addList(_ list: TaskList) {
        let realmList = RealmTaskList(from: list)
        try! realm.write {
            realm.add(realmList, update: .modified)
        }
    }

    func updateList(_ list: TaskList) {
        addList(list)
    }

    func deleteList(by id: UUID) {
        guard let object = realm.object(ofType: RealmTaskList.self, forPrimaryKey: id.uuidString) else { return }
        try! realm.write {
            realm.delete(object)
        }
    }
    func create(taskList: TaskList) {
        // Сохраняем через Realm или другой механизм
    }

}
