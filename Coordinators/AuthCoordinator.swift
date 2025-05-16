import UIKit

final class AuthCoordinator {
    private let navigationController: UINavigationController
    private let taskRepository: TaskRepository
    private let taskListRepository: TaskListRepository
    private let noteRepository: NoteRepository

    // MARK: - Auth success handler
    var onAuthSuccess: (() -> Void)?  // ← обновлено

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.taskRepository = TaskRepository()
        self.taskListRepository = TaskListRepository()
        self.noteRepository = NoteRepository()
    }

    func start() {
        let authService = AuthenticationService()
        let loginVM = LoginViewModel(authService: authService, coordinator: self)
        let loginVC = LoginViewController(viewModel: loginVM)
        navigationController.setViewControllers([loginVC], animated: false)
    }

    func showMainScreen(for userId: String) {
        guard let uuid = UUID(uuidString: userId) else {
            print("❌ Invalid UUID string: \(userId)")
            return
        }

        let getTasksUseCase = GetTasksForDateUseCase(taskRepository: taskRepository)

        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            taskRepository: taskRepository,
            taskListRepository: taskListRepository,
            noteRepository: noteRepository,
            getTasksUseCase: getTasksUseCase,
            userId: uuid
        )

        mainCoordinator.start()

        // вызвать callback
        onAuthSuccess?()
    }
}
