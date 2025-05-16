import Foundation

final class GetTasksForDateUseCase {
    private let taskRepository: TaskRepository

    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    func execute(date: Date) -> [Task] {
        return taskRepository.getAllTasks().filter {
            guard let dueDate = $0.dueDate else { return false }
            return Calendar.current.isDate(dueDate, inSameDayAs: date)
        }
    }

}
