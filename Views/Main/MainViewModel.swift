import Foundation
final class MainViewModel {
        private(set) var currentSection: MainSection = .todayTasks
        
        func select(section: MainSection) {
            currentSection = section
            // Handle loading corresponding view controller
            print("Switched to section: \(section)")
        }
    }

