enum AppTheme: String, Codable {
case light
case dark
case system
}

final class ThemeService {
private var currentTheme: AppTheme = .system

func setTheme(_ theme: AppTheme) {
    currentTheme = theme
    // Apply to UI if needed
}

func getTheme() -> AppTheme {
    return currentTheme
}
}
