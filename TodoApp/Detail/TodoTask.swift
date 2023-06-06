import Foundation

struct TodoTask: Identifiable {
    var id: String
    var text: String
    var important: Important
    var deadline: Date?
    var isDone: Bool
    var dateСreation: Date
    var dateChange: Date?
    init(
        id: String = UUID().uuidString,
        text: String,
        important: Important = .normal,
        deadline: Date?,
        isDone: Bool,
        dateСreation: Date,
        dateChange: Date?
    ) {
        self.id = id
        self.text = text
        self.important = important
        self.deadline = deadline
        self.isDone = isDone
        self.dateСreation = dateСreation
        self.dateChange = dateChange
    }
    enum Important: Int {
        case unimportant, normal, important
    }
    mutating func changeImportant(important: Int) {
        self.important = Important(rawValue: important) ?? .normal
    }
    mutating func changeTask(
        text: String,
        important: Int,
        deadlineTime: Date?,
        changeTime: Date?
    ) {
        self.text = text
        self.important = Important(rawValue: important) ?? .normal
        if let deadlineTime {
            self.deadline = deadlineTime
        }
        if let changeTime {
            self.dateChange = changeTime
        }
    }
}
extension TodoTask {
    enum Keys: String {
        case id
        case text
        case important
        case deadline
        case isDone
        case dateСreation
        case dateChange
    }
    var json: Any {
        var todoJson: [String: Any] = [
            Keys.id.rawValue: id,
            Keys.text.rawValue: text,
            Keys.isDone.rawValue: isDone,
            Keys.dateСreation.rawValue: dateСreation.timeIntervalSinceReferenceDate
        ]
        if important != .normal {
            let importantValue = important.rawValue
            todoJson.updateValue(importantValue, forKey: Keys.important.rawValue)
        }
        if let deadline {
            todoJson.updateValue(
                deadline.timeIntervalSinceReferenceDate,
                forKey: Keys.deadline.rawValue
            )
        }
        if let dateChange {
            todoJson.updateValue(
                dateChange.timeIntervalSinceReferenceDate,
                forKey: Keys.dateChange.rawValue
            )
        }
        return todoJson
    }
    static func parse(json: Any) -> TodoTask? {
        guard let todoJson = json as? [String: Any] else { return nil }
        var deadlineDate: Date?
        if let deadlineTime = todoJson[Keys.deadline.rawValue] as? TimeInterval {
            deadlineDate = Date(timeIntervalSinceReferenceDate: deadlineTime)
        }
        var dateChange: Date?
        if let dateChangeTime = todoJson[Keys.dateChange.rawValue] as? TimeInterval {
            dateChange = Date(timeIntervalSinceReferenceDate: dateChangeTime)
        }
        let dateСreation = Date(
            timeIntervalSinceReferenceDate: (todoJson[Keys.dateСreation.rawValue] as? TimeInterval) ?? 0
        )
        return TodoTask(
            id: todoJson[Keys.id.rawValue] as? String ?? "",
            text: todoJson[Keys.text.rawValue] as? String ?? "",
            important: Important(rawValue: todoJson[Keys.important.rawValue] as? Int ?? 1) ?? .normal,
            deadline: deadlineDate,
            isDone: todoJson[Keys.isDone.rawValue] as? Bool ?? false,
            dateСreation: dateСreation,
            dateChange: dateChange
        )
    }
}
