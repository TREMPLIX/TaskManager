import Foundation

final class CreateListViewModel {
        private let taskListRepository: TaskListRepository
    private weak var coordinator: MainCoordinator?
        private let userId: UUID

        init(taskListRepository: TaskListRepository, coordinator: MainCoordinator, userId: UUID) {
            self.taskListRepository = taskListRepository
            self.coordinator = coordinator
            self.userId = userId
        }

        func createList(with title: String) {
            let newList = TaskList(id: UUID(), title: title, userId: userId)
            taskListRepository.create(taskList: newList)
            coordinator?.dismissCreateList()
        }
    

    private func colorFromIndex(_ index: Int) -> String {
        switch index {
        case 0: return "red"
        case 1: return "green"
        case 2: return "blue"
        case 3: return "yellow"
        case 4: return "purple"
        default: return "gray"
        }
    }
}

