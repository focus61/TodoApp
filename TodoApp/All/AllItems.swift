//
//  AllItems.swift
//  TodoApp
//
//  Created by Aleksandr on 02.06.2023.
//

import Foundation
struct AllItems {
    var tasks: [TodoTask]
    var isLoad: Bool
    mutating func loadTasks(tasks: [TodoTask]) {
        self.tasks = tasks
        self.isLoad = true
    }
}
