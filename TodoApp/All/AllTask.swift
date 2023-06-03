//
//  AllTask.swift
//  TodoApp
//
//  Created by Aleksandr on 01.06.2023.
//

import Foundation
import Combine

protocol Task {
    func deleteTask(by uuid: String)
    func saveTask(_ item: TodoTask)
}

final class AllTask: ObservableObject, Task {
    static let notificationName: String = "notificationName"
    private let dateFormatter = DateFormatter()
    let fileCache = FileCache()
    @Published private(set) var allItems: AllItems
    var isLoad: Bool {
        return allItems.isLoad
    }
    init(items: AllItems = AllItems(tasks: [], isLoad: false)) {
        allItems = items
        NotificationCenter.default.addObserver(self, selector: #selector(updateAllTask), name: Notification.Name(AllTask.notificationName), object: nil)
    }
    @objc private func updateAllTask() {
        self.fileCache.loadFromFile { newItems in self.allItems.loadTasks(tasks: newItems) }
    }
    deinit {
        NotificationCenter.default.removeObserver(Notification(name: Notification.Name(AllTask.notificationName)))
    }
    func loadFromFileCache() {
        fileCache.loadFromFile { newItems in self.allItems.loadTasks(tasks: newItems) }
    }
    func deleteTask(by uuid: String) {
        fileCache.deleteTask(by: uuid)
        fileCache.saveToFile { isSuccess in
            self.fileCache.loadFromFile { newItems in self.allItems.loadTasks(tasks: newItems) }
        }
    }
    func saveTask(_ item: TodoTask) {
        fileCache.addTask(item)
    }
    func dateToString(_ date: Date?) -> String? {
        if let date {
            dateFormatter.dateFormat = "d MMMM yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
