import Foundation

final class DeleteTaskUseCase {
    private let taskRepository: TaskRepository

    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    func execute(taskId: UUID) {
        taskRepository.deleteTask(by: taskId)
    }
}
