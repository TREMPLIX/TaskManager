import UIKit

final class AppCoordinator {
    private let window: UIWindow

    private let authService:AuthenticationService = AuthenticationService()
    private let taskRepository:TaskRepository = TaskRepository()
    private let taskListRepository:TaskListRepository = TaskListRepository()
    private let noteRepository:NoteRepository = NoteRepository()
    private let navigationController: UINavigationController
    private let getTasksForDateUseCase: GetTasksForDateUseCase

    private var authCoordinator: AuthCoordinator?
    private var mainCoordinator: MainCoordinator?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()

        // UseCase зависит от taskRepository
        self.getTasksForDateUseCase = GetTasksForDateUseCase(taskRepository: self.taskRepository as TaskRepository)

    }

    func start() {
        let navigationController = UINavigationController()
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.onAuthSuccess = {
            // Код, который запускает экран после успешной аутентификации
        }
        authCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }


    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController
        )

        authCoordinator.onAuthSuccess = { [weak self] in
            guard let self = self, let userId = self.authService.getCurrentUserId() else { return }
            self.showMainFlow(userId: userId)
        }

        self.authCoordinator = authCoordinator

        window.rootViewController = navigationController
        authCoordinator.start()
        window.makeKeyAndVisible()
    }

    private func showMainFlow(userId: UUID) {
        let mainCoordinator: MainCoordinator = MainCoordinator(
            navigationController: navigationController,
            taskRepository: taskRepository,
            taskListRepository: taskListRepository,
            noteRepository: noteRepository,
            getTasksUseCase: getTasksForDateUseCase,
            userId: userId
        )

        self.mainCoordinator = mainCoordinator

        window.rootViewController = navigationController
        mainCoordinator.start()
        window.makeKeyAndVisible()
    }
}
