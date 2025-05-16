enum MainSection {
    case todayTasks, calendar, kanban, notes, trash
    
    var title: String {
        switch self {
        case .todayTasks: return "Tasks"
        case .calendar: return "Calendar"
        case .notes: return "Notes"
        case .kanban: return "Kanban"
        case .trash: return "Trash"
        }
    }
}
