import Foundation
import RealmSwift

class RealmUser: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var firstName: String?
    @Persisted var lastName: String?
    @Persisted var email: String
    @Persisted var passwordHash: String
    @Persisted var nickname: String?
    @Persisted var birthDate: Date?
    @Persisted var genderRaw: String?
    @Persisted var profilePictureURLString: String?
    @Persisted var registrationDate: Date
    @Persisted var lastLoginDate: Date?
    @Persisted var isEmailVerified: Bool
    @Persisted var isAccountActive: Bool
    @Persisted var isAccountLocked: Bool
    @Persisted var failedLoginAttempts: Int
    @Persisted var preferredLanguage: String
    @Persisted var timeZone: String
    @Persisted var isNotificationsEnabled: Bool
    @Persisted var enableEmailNotifications: Bool
    @Persisted var enablePushNotifications: Bool
    @Persisted var enableInAppNotifications: Bool
    @Persisted var isDarkModeEnabled: Bool
    @Persisted var roleRaw: String
    @Persisted var isTwoFactorEnabled: Bool
    @Persisted var twoFactorSecret: String?
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var createdBy: UUID?
    @Persisted var updatedBy: UUID?
}

extension RealmUser {
    convenience init(user: User) {
        self.init()
        self.id = user.id
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.email = user.email
        self.passwordHash = user.passwordHash
        self.nickname = user.nickname
        self.birthDate = user.birthDate
        self.genderRaw = user.gender?.rawValue
        self.profilePictureURLString = user.profilePictureURL?.absoluteString
        self.registrationDate = user.registrationDate
        self.lastLoginDate = user.lastLoginDate
        self.isEmailVerified = user.isEmailVerified
        self.isAccountActive = user.isAccountActive
        self.isAccountLocked = user.isAccountLocked
        self.failedLoginAttempts = user.failedLoginAttempts
        self.preferredLanguage = user.preferredLanguage
        self.timeZone = user.timeZone
        self.isNotificationsEnabled = user.isNotificationsEnabled
        self.enableEmailNotifications = user.notificationPreferences.enableEmailNotifications
        self.enablePushNotifications = user.notificationPreferences.enablePushNotifications
        self.enableInAppNotifications = user.notificationPreferences.enableInAppNotifications
        self.isDarkModeEnabled = user.isDarkModeEnabled
        self.roleRaw = user.role.rawValue
        self.isTwoFactorEnabled = user.isTwoFactorEnabled
        self.twoFactorSecret = user.twoFactorSecret
        self.createdAt = user.createdAt
        self.updatedAt = user.updatedAt
        self.createdBy = user.createdBy
        self.updatedBy = user.updatedBy
    }

    func toUser() -> User {
        return User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            passwordHash: passwordHash,
            nickname: nickname,
            birthDate: birthDate,
            gender: genderRaw.flatMap(Gender.init(rawValue:)),
            profilePictureURL: profilePictureURLString.flatMap(URL.init(string:)),
            registrationDate: registrationDate,
            lastLoginDate: lastLoginDate,
            isEmailVerified: isEmailVerified,
            isAccountActive: isAccountActive,
            isAccountLocked: isAccountLocked,
            failedLoginAttempts: failedLoginAttempts,
            preferredLanguage: preferredLanguage,
            timeZone: timeZone,
            isNotificationsEnabled: isNotificationsEnabled,
            notificationPreferences: .init(
                enableEmailNotifications: enableEmailNotifications,
                enablePushNotifications: enablePushNotifications,
                enableInAppNotifications: enableInAppNotifications
            ),
            isDarkModeEnabled: isDarkModeEnabled,
            role: UserRole(rawValue: roleRaw) ?? .user,
            isTwoFactorEnabled: isTwoFactorEnabled,
            twoFactorSecret: twoFactorSecret,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy
        )
    }
}
