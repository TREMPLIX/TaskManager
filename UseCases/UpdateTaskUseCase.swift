import Foundation

final class UpdateTaskUseCase {
    private let taskRepository: TaskRepository

    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    func execute(task: Task) {
        taskRepository.updateTask(task)
    }
}
