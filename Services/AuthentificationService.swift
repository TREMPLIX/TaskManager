import Foundation

final class AuthenticationService {
    private var currentUserId: UUID?

    func register(email: String, password: String) -> UUID {
        // Dummy implementation
        let userId = UUID()
        currentUserId = userId
        return userId
    }

//    func login(email: String, password: String) -> UUID? {
//        // Dummy login validation
//        let userId = UUID()
//        currentUserId = userId
//        return userId
//    }
    func login(email: String, password: String, completion: @escaping (Result<UUID, Error>) -> Void) {
        let fakeId = UUID()
        currentUserId = fakeId
        completion(.success(fakeId))
    }

    func logout() {
        currentUserId = nil
    }

    func getCurrentUserId() -> UUID? {
        return currentUserId
    }
}
