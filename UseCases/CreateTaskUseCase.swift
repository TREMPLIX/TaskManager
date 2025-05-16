import Foundation

final class CreateTaskUseCase {
    private let taskRepository: TaskRepository

    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    func execute(task: Task) {
        taskRepository.addTask(task)
    }
}
