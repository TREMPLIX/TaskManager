import Foundation

final class TaskDetailViewModel {
    private let taskRepository: TaskRepository
    private let taskId: UUID

    private(set) var task: Task?

    init(taskRepository: TaskRepository, taskId: UUID) {
        self.taskRepository = taskRepository
        self.taskId = taskId
    }

    func loadTask() {
        task = taskRepository.getTask(by: taskId)
    }

    func updateTask(title: String, description: String, dueDate: Date?) {
        guard var task = task else { return }
        task.title = title
        task.description = description
        task.dueDate = dueDate
        taskRepository.updateTask(task)
    }
}
