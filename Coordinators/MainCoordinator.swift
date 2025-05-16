import UIKit

final class MainCoordinator {
    let navigationController: UINavigationController
    private let taskRepository: TaskRepository
    private let noteRepository: NoteRepository
    private let taskListRepository: TaskListRepository
    private let getTasksUseCase: GetTasksForDateUseCase
    private let userId: UUID

    init(
        navigationController: UINavigationController,
        taskRepository: TaskRepository,
        taskListRepository: TaskListRepository,
        noteRepository: NoteRepository,
        getTasksUseCase: GetTasksForDateUseCase,
        userId: UUID
    ) {
        self.navigationController = navigationController
        self.taskRepository = taskRepository
        self.noteRepository = noteRepository
        self.getTasksUseCase = getTasksUseCase
        self.taskListRepository = taskListRepository
        self.userId = userId
    }

    func start() {
        let sidebarVM = SidebarViewModel()
        sidebarVM.coordinator = self
        
        let sidebarVC = SidebarViewController(viewModel: sidebarVM)

        let mainVM = MainViewModel()
        let mainVC = MainViewController(viewModel: mainVM, sidebarVC: sidebarVC)

        navigationController.setViewControllers([mainVC], animated: true)
    }

    func showTaskDetail(taskId: UUID) {
        let detailVM = TaskDetailViewModel(taskRepository: taskRepository, taskId: taskId)
        let detailVC = TaskDetailViewController(viewModel: detailVM)
        navigationController.pushViewController(detailVC, animated: true)
    }

    func showTaskList() {
        let taskListVM = TaskListViewModel(
            taskRepository: taskRepository,
            getTasksForDateUseCase: getTasksUseCase
        )
        let taskListVC = TaskListViewController(viewModel: taskListVM)
        navigationController.pushViewController(taskListVC, animated: true)
    }

    func showCalendar() {
        let calendarVM = CalendarViewModel(getTasksForDateUseCase: getTasksUseCase)
        let calendarVC = CalendarViewController(viewModel: calendarVM)
        navigationController.pushViewController(calendarVC, animated: true)
    }

    func showKanban() {
        let kanbanVM = KanbanBoardViewModel(taskRepository: taskRepository)
        let kanbanVC = KanbanBoardViewController(viewModel: kanbanVM)
        navigationController.pushViewController(kanbanVC, animated: true)
    }


    func showCreateListScreen() {
        let viewModel = CreateListViewModel(
            taskListRepository: taskListRepository,
            coordinator: self,
            userId: userId // ← убедись, что у тебя есть это свойство в MainCoordinator
        )
        let createListVC = CreateListViewController(viewModel: viewModel)
        navigationController.pushViewController(createListVC, animated: true)
    }


    func showNotes() {
        let notesListVM = NotesListViewModel(noteRepository: self.noteRepository, taskRepository: self.taskRepository, coordinator: self)
        let notesListVC = NotesListViewController(viewModel: notesListVM)
        navigationController.pushViewController(notesListVC, animated: true)
    }

    func showTrash() {
        let trashVM = TrashViewModel(repository: taskRepository)
        let trashVC = TrashViewController(viewModel: trashVM)
        navigationController.pushViewController(trashVC, animated: true)
    }
    func dismissCreateList() {
        navigationController.popViewController(animated: true)
    }
    
    func showNoteDetail(note: Note) {
        let viewModel = NoteDetailViewModel(note: note)
        let viewController = NoteDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    
}
