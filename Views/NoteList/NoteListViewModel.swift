import Foundation

final class NotesListViewModel {
    private let noteRepository: NoteRepository
    private let taskRepository: TaskRepository
    private weak var coordinator: MainCoordinator?

    private(set) var notes: [Note] = []

    init(noteRepository: NoteRepository, taskRepository: TaskRepository, coordinator: MainCoordinator) {
        self.noteRepository = noteRepository
        self.taskRepository = taskRepository
        self.coordinator = coordinator
    }

    func loadNotes() {
        notes = noteRepository.getAllNotes()
    }

    func didSelectNote(at index: Int) {
        let note = notes[index]
        coordinator?.showNoteDetail(note: note)
    }
}
