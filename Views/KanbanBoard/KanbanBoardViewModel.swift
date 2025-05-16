final class KanbanBoardViewModel {
    private let taskRepository: TaskRepository
    private var allTasks: [Task] = []

    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    func loadTasks() {
        allTasks = taskRepository.getAllTasks()
    }

    func tasks(for status: TaskStatus) -> [Task] {
        return allTasks.filter { $0.status == status }
    }
}
