//
//  AllTaskList.swift
//  TodoApp
//
//  Created by Aleksandr on 06.06.2023.
//

import SwiftUI

struct AllTaskList: View {
    @ObservedObject var allTaskViewModel: AllTask
    @State private var isSharePresented = false
    var body: some View {
        if allTaskViewModel.isLoad {
            if allTaskViewModel.allItems.tasks.isEmpty {
                Text("No tasks").foregroundColor(.gray).font(.largeTitle)
            } else {
                List(allTaskViewModel.allItems.tasks) { task in
                    NavigationLink {
                        let detailTask = DetailTask(model: task, fileCache: allTaskViewModel.fileCache)
                        TaskDetailView(viewModel: detailTask)
                    } label: {
                        AllTaskRow(
                            taskText: task.text,
                            isDone: task.isDone,
                            isOverdueDeadline: task.isDone,
                            importantRow: task.important.rawValue,
                            deadlineTimeDescription: allTaskViewModel.dateToString(task.deadline)
                        )
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }.tint(.green)
                    .swipeActions(edge: .trailing) {
                            Button {
                                allTaskViewModel.deleteTask(by: task.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                    }
                    .tint(.red)
                    .swipeActions(edge: .trailing) {
                            Button {
                                
                            } label: {
                                Image(systemName: "info.circle.fill")
                            }
                    }
                    .contextMenu(menuItems: {
                        Button {
                            self.isSharePresented = true
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        Menu {
                            Button {
                                allTaskViewModel.changeImportant(for: task.id, important: 0)
                            } label: {
                                Label("Unimportant", systemImage: "arrow.down")
                            }
                            Button() {
                                allTaskViewModel.changeImportant(for: task.id, important: 1)
                            } label: {
                                Label("normal", systemImage: "line.3.horizontal")
                            }
                            Button(role: .destructive) {
                                allTaskViewModel.changeImportant(for: task.id, important: 2)
                            } label: {
                                Label("Important", systemImage: "exclamationmark.2")
                            }
                            
                        } label: {
                            Label("Change important", systemImage: "arrow.up.arrow.down")
                        }
                        
                        Button(role: .destructive) {
                            allTaskViewModel.deleteTask(by: task.id)
                        } label: {
                            Label("Delete", systemImage: "minus.circle")
                        }
                    })
                    .menuStyle(.borderlessButton)
                    .tint(.gray)
                }
                .sheet(isPresented: $isSharePresented, onDismiss: {
                    print("Dismiss")
                }, content: {
                    ActivityViewController(activityItems: [URL(string: "https://www.apple.com")!])
                })
            }
        } else {
            ProgressView().tint(.blue)
        }
    }
}

struct AllTaskList_Previews: PreviewProvider {
    static var previews: some View {
        AllTaskList(allTaskViewModel: AllTask(items: AllItems(tasks: [TodoTask(text: "asd", deadline: Date(), isDone: false, dateСreation: Date(), dateChange: nil), TodoTask(text: "asd", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil), TodoTask(text: "asd", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil), TodoTask(text: "asd", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil)], isLoad: true)))
    }
}
