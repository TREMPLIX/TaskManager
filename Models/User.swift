import Foundation

enum Gender: String, Codable {
    case male
    case female
    case other
}

enum UserRole: String, Codable {
    case user
    case admin
}

struct User: Identifiable, Codable {
    let id: UUID
    var firstName: String?
    var lastName: String?
    var email: String
    var passwordHash: String
    var nickname: String?
    var birthDate: Date?
    var gender: Gender?
    var profilePictureURL: URL?
    var registrationDate: Date
    var lastLoginDate: Date?
    var isEmailVerified: Bool
    var isAccountActive: Bool
    var isAccountLocked: Bool
    var failedLoginAttempts: Int
    var preferredLanguage: String
    var timeZone: String
    var isNotificationsEnabled: Bool
    var notificationPreferences: NotificationPreferences // Added
    var isDarkModeEnabled: Bool
    var role: UserRole // Added
    var isTwoFactorEnabled: Bool // Added
    var twoFactorSecret: String? // Added
    let createdAt: Date
    var updatedAt: Date
    let createdBy: UUID? // Added
    let updatedBy: UUID? // Added

    struct NotificationPreferences: Codable {
        var enableEmailNotifications: Bool
        var enablePushNotifications: Bool
        var enableInAppNotifications: Bool
    }

    init(
        id: UUID = UUID(),
        firstName: String? = nil,
        lastName: String? = nil,
        email: String,
        passwordHash: String,
        nickname: String? = nil,
        birthDate: Date? = nil,
        gender: Gender? = nil,
        profilePictureURL: URL? = nil,
        registrationDate: Date = Date(),
        lastLoginDate: Date? = nil,
        isEmailVerified: Bool = false,
        isAccountActive: Bool = true,
        isAccountLocked: Bool = false,
        failedLoginAttempts: Int = 0,
        preferredLanguage: String = "en",
        timeZone: String = TimeZone.current.identifier,
        isNotificationsEnabled: Bool = true,
        notificationPreferences: NotificationPreferences = .init(
            enableEmailNotifications: true,
            enablePushNotifications: true,
            enableInAppNotifications: true
        ),
        isDarkModeEnabled: Bool = false,
        role: UserRole = .user,
        isTwoFactorEnabled: Bool = false,
        twoFactorSecret: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        createdBy: UUID? = nil,
        updatedBy: UUID? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.nickname = nickname
        self.birthDate = birthDate
        self.gender = gender
        self.profilePictureURL = profilePictureURL
        self.registrationDate = registrationDate
        self.lastLoginDate = lastLoginDate
        self.isEmailVerified = isEmailVerified
        self.isAccountActive = isAccountActive
        self.isAccountLocked = isAccountLocked
        self.failedLoginAttempts = failedLoginAttempts
        self.preferredLanguage = preferredLanguage
        self.timeZone = timeZone
        self.isNotificationsEnabled = isNotificationsEnabled
        self.notificationPreferences = notificationPreferences
        self.isDarkModeEnabled = isDarkModeEnabled
        self.role = role
        self.isTwoFactorEnabled = isTwoFactorEnabled
        self.twoFactorSecret = twoFactorSecret
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.createdBy = createdBy
        self.updatedBy = updatedBy
    }

    mutating func incrementFailedLoginAttempts() {
        failedLoginAttempts += 1
        updatedAt = Date()
    }

    mutating func resetFailedLoginAttempts() {
        failedLoginAttempts = 0
        updatedAt = Date()
    }

    mutating func lockAccount() {
        isAccountLocked = true
        updatedAt = Date()
    }

    mutating func unlockAccount() {
        isAccountLocked = false
        updatedAt = Date()
    }

    mutating func verifyEmail() {
        isEmailVerified = true
        updatedAt = Date()
    }

    mutating func updateLastLogin() {
        lastLoginDate = Date()
        updatedAt = Date()
    }
}
