import Foundation
import RealmSwift

protocol UserRepository {
    func getUser(by id: UUID) -> User?
    func getAllUsers() -> [User]
    func addUser(_ user: User)
    func updateUser(_ user: User)
    func deleteUser(by id: UUID)
}

final class RealmUserRepository: UserRepository {
    private let realm = try! Realm()

    func getUser(by id: UUID) -> User? {
        return realm.object(ofType: RealmUser.self, forPrimaryKey: id)?.toUser()
    }

    func getAllUsers() -> [User] {
        return realm.objects(RealmUser.self).map { $0.toUser() }
    }

    func addUser(_ user: User) {
        let realmUser = RealmUser(user: user)
        try? realm.write {
            realm.add(realmUser, update: .modified)
        }
    }

    func updateUser(_ user: User) {
        addUser(user) // add with `.modified` updates existing
    }

    func deleteUser(by id: UUID) {
        guard let user = realm.object(ofType: RealmUser.self, forPrimaryKey: id) else { return }
        try? realm.write {
            realm.delete(user)
        }
    }
}
