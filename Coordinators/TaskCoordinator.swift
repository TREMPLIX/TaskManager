import UIKit

final class TaskCoordinator {
    private let navigationController: UINavigationController
    private let taskRepository: TaskRepository

    init(navigationController: UINavigationController, taskRepository: TaskRepository) {
        self.navigationController = navigationController
        self.taskRepository = taskRepository
    }

    func showTaskDetails(taskId: UUID) {
        let viewModel = TaskDetailViewModel(taskRepository: taskRepository, taskId: taskId)
        let vc = TaskDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func showCreateTask() {
        let viewModel = CreateTaskViewModel(taskRepository: taskRepository) { [weak self] task in
            self?.showTaskDetails(taskId: task.id)
        }

        let vc = CreateTaskViewController(viewModel: viewModel)
        navigationController.present(vc, animated: true)
    }
}
