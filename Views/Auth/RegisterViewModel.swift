import Foundation

final class RegisterViewModel {
    private let authService: AuthenticationService
    private let coordinator: AuthCoordinator

    init(authService: AuthenticationService, coordinator: AuthCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func register(email: String, password: String) {
        authService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userId):
                self?.coordinator.showMainScreen(for: userId.uuidString)
            case .failure(let error):
                // Обработка ошибки регистрации, например:
                print("Ошибка авторизации: \(error)")
            }
        }
    }


    }

