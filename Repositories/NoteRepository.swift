import Foundation
import RealmSwift

final class NoteRepository {
    private let realm = try! Realm()

    func getNote(by id: UUID) -> Note? {
        guard let object = realm.object(ofType: RealmNote.self, forPrimaryKey: id.uuidString) else { return nil }
        return object.toStruct()
    }

    func getAllNotes() -> [Note] {
        return realm.objects(RealmNote.self).map { $0.toStruct() }
    }

    func addNote(_ note: Note) {
        let realmNote = RealmNote(from: note)
        try! realm.write {
            realm.add(realmNote, update: .modified)
        }
    }

    func updateNote(_ note: Note) {
        addNote(note)
    }

    func deleteNote(by id: UUID) {
        guard let object = realm.object(ofType: RealmNote.self, forPrimaryKey: id.uuidString) else { return }
        try! realm.write {
            realm.delete(object)
        }
    }
}
