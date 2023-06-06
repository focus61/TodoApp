import Foundation

protocol Task {
    func deleteTask(by uuid: String)
    func saveTask(_ item: TodoTask)
}

final class AllTask: ObservableObject, Task {
    private let dateFormatter = DateFormatter()
    let fileCache = FileCache()
    @Published private(set) var allItems: AllItems
    var isLoad: Bool {
        return allItems.isLoad
    }
    init(items: AllItems = AllItems(tasks: [], isLoad: false)) {
        allItems = items
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
    func changeImportant(for taskID: String, important: Int) {
        let index = allItems.tasks.firstIndex(where: { $0.id == taskID }) ?? 0
        allItems.tasks[index].changeImportant(important: important)
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

