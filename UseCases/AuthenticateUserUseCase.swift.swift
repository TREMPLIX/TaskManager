import Foundation

struct AuthenticateUserUseCase {
    private let authService: AuthenticationService

    init(authService: AuthenticationService) {
        self.authService = authService
    }

    func execute(email: String, password: String, completion: @escaping (Result<UUID, Error>) -> Void) {
            authService.login(email: email, password: password, completion: completion)
        }
}
