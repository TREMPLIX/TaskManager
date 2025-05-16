import Foundation

final class CalendarViewModel {
    private let getTasksForDateUseCase: GetTasksForDateUseCase
    private(set) var tasks: [Task] = []

    init(getTasksForDateUseCase: GetTasksForDateUseCase) {
        self.getTasksForDateUseCase = getTasksForDateUseCase
    }

    func loadTasks(for date: Date) {
        tasks = getTasksForDateUseCase.execute(date: date)
    }
}
