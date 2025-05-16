import Foundation

final class LoginViewModel {
    private let authService: AuthenticationService
    weak var coordinator: AuthCoordinator?

    init(authService: AuthenticationService, coordinator: AuthCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func login(email: String, password: String) {
        authService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let userId):
                print("Login succeeded, userId: \(userId)")
                self?.coordinator?.showMainScreen(for: userId.uuidString)
            case .failure(let error):
                print("Login failed with error: \(error)")
            }
        }
    }

}
