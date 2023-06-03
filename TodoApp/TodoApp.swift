//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Aleksandr on 31.05.2023.
//

import SwiftUI

@main
struct TodoApp: App {
    private let allTasks = AllTask()
    var body: some Scene {
        WindowGroup {
            AllTaskView(allTaskViewModel: allTasks)
        }
    }
}
