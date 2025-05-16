import Foundation

final class SidebarViewModel {
    let sections: [MainSection] = [.todayTasks, .calendar, .kanban, .notes, .trash]
    
    weak var coordinator: MainCoordinator?
}
