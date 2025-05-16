// TaskStatus.swift
import Foundation

enum TaskStatus: String, Codable, CaseIterable {
    case blocked
    case deferred
    case notStarted = "Не начата"
    case inProgress = "В процессе"
    case completed = "Завершена"
    case onHold = "На паузе"
    case cancelled = "Отменена"
    case todo = "Нужно выполнить"
    case done = "Выполнено"
}
