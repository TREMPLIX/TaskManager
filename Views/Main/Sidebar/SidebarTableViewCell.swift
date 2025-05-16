import UIKit

final class SidebarTableViewCell: UITableViewCell {
    func configure(with section: MainSection) {
        switch section {
        case .todayTasks:
            textLabel?.text = "Today's Tasks"
        case .calendar:
            textLabel?.text = "Calendar"
        case .kanban:
            textLabel?.text = "Kanban Board"
        case .notes:
            textLabel?.text = "Notes"
        case .trash:
            textLabel?.text = "Trash"
        }
        textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
}
