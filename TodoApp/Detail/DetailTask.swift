//
//  DetailTask.swift
//  TodoApp
//
//  Created by Aleksandr on 01.06.2023.
//

import Foundation

final class DetailTask: ObservableObject {
    @Published private var model: TodoTask
    @Published var text: String
    @Published var importantIndex: Int
    @Published var isDeadlineOn: Bool
    @Published var selectedDateInCalendar: Date
    private let dateFormatter = DateFormatter()
    private let fileCache: FileCache
    private func saveToFileCache() {
        fileCache.saveToFile { isSuccess in
            if !isSuccess { fatalError("saveToFile") }
            NotificationCenter.default.post(Notification(name: Notification.Name(AllTask.notificationName)))
        }
    }
    func deleteTask(by uuid: String) {
        fileCache.deleteTask(by: uuid)
    }
    func saveTask() {
        fileCache.addTask(model)
        saveToFileCache()
    }
    func changeTask(deadline: Date?) {
        model.changeTask(
            text: text,
            important: importantIndex,
            deadlineTime: deadline,
            changeTime: nil
        )
    }
    func dateToString() -> String {
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: selectedDateInCalendar)
    }
    init(model: TodoTask = TodoTask(text: "", deadline: nil, isDone: false, dateСreation: Date(), dateChange: nil), fileCache: FileCache) {
        self.model = model
        self.text = model.text
        self.importantIndex = model.important.rawValue
        self.isDeadlineOn = model.deadline != nil
        self.selectedDateInCalendar = model.deadline ?? Date()
        self.fileCache = fileCache
    }
}
