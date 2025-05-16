import Foundation

final class TrashViewModel {
    private let repository: TaskRepository

    private(set) var deletedTasks: [Task] = []

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func loadDeletedItems() {
        deletedTasks = repository.getAllTasks().filter { $0.isDeleted }
    }

    func restoreTask(at index: Int) {
        var task = deletedTasks[index]
        task.isDeleted = false
        repository.updateTask(task)
        loadDeletedItems()
    }

    func permanentlyDeleteTask(at index: Int) {
        let task = deletedTasks[index]
        repository.deleteTask(by: task.id)
        loadDeletedItems()
    }
}
