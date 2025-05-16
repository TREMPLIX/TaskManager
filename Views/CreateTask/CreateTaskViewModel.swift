import Foundation

final class CreateTaskViewModel {
    var onTaskCreated: ((Task) -> Void)?
    private let taskRepository: TaskRepository

    init(taskRepository: TaskRepository, onTaskCreated: ((Task) -> Void)? = nil) {
        self.taskRepository = taskRepository
        self.onTaskCreated = onTaskCreated
    }

    func createTask(title: String) {
        let task = Task(id: UUID(), title: title, dueDate: Date(), isCompleted: false)
        taskRepository.addTask(task)
        onTaskCreated?(task)
    }
}
