import Foundation

final class TaskListViewModel {
    private let taskRepository: TaskRepository
    private let getTasksForDateUseCase: GetTasksForDateUseCase

    private(set) var tasks: [Task] = []
    var onTasksUpdated: (() -> Void)?

    init(taskRepository: TaskRepository, getTasksForDateUseCase: GetTasksForDateUseCase) {
        self.taskRepository = taskRepository
        self.getTasksForDateUseCase = getTasksForDateUseCase
    }

    func fetchTasks(for date: Date = Date()) {
        tasks = getTasksForDateUseCase.execute(date: date)
        onTasksUpdated?()
    }
}
