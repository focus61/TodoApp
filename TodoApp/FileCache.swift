import Foundation

final class FileCache {
    static let fileName = "TodoItems Tasks"
    private(set) var todoItems: [String: TodoTask]
    init(todoItems: [String: TodoTask] = [:]) {
        self.todoItems = todoItems
    }
    func addTask(_ todoItem: TodoTask) {
        todoItems.updateValue(todoItem, forKey: todoItem.id)
    }
    func deleteTask(by uuid: String) {
        todoItems.removeValue(forKey: uuid)
    }
    func saveToFile(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let file = documentDirectory.appendingPathComponent(FileCache.fileName, conformingTo: .toDoItem)
            let jsonArray = self.todoItems.map { _, item in
                item.json as? [String: Any]
            }
            guard let writeToFile = try? JSONSerialization.data(withJSONObject: jsonArray, options: []) else {
                completion(false)
                return
            }
            guard let _ = try? writeToFile.write(to: file) else {
                completion(false)
                return
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    func loadFromFile(completion: @escaping ([TodoTask]) -> Void) {
        DispatchQueue.global().async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let file = documentDirectory.appendingPathComponent(FileCache.fileName, conformingTo: .toDoItem)
            guard let data = try? Data(contentsOf: file),
                  let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            else {
                return
            }
            
            let newArray = jsonArray.reduce(into: [String: TodoTask]()) {
                if let item = TodoTask.parse(json: $1) {
                    $0[item.id] = item
                }
            }
            self.todoItems = newArray
            DispatchQueue.main.async {
                completion(newArray.map { $0.value }.sorted { $0.dateСreation < $1.dateСreation } )
            }
        }
    }
}
