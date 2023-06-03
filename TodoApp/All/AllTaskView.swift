//
//  ContentView.swift
//  TodoApp
//
//  Created by Aleksandr on 31.05.2023.
//

import SwiftUI
//TODO: - Краткая информация по свайпу, isDone по свайпу, при лонг тапе на ячейку показывать краткое меню
struct AllTaskView: View {
    @ObservedObject var allTaskViewModel: AllTask
    private let color = Color(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1))
    private let addTaskButtonSize = CGSize(width: 50, height: 50)
    private let addTaskButtonShadowRadius: CGFloat = 3
    var body: some View {
        NavigationView {
            ZStack {
                color.ignoresSafeArea()
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
                                    importantRow: task.important.rawValue
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
                            .tint(.gray)
                        }
                    }
                } else {
                    ProgressView().tint(.blue)
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink {
                            let detailTask = DetailTask(fileCache: allTaskViewModel.fileCache)
                            TaskDetailView(viewModel: detailTask)
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: addTaskButtonSize.width, height: addTaskButtonSize.height)
                                Image(systemName: "plus")
                                    .foregroundColor(.white
                                    )
                                    .font(.title)
                            }
                            .foregroundColor(.blue)
                            .shadow(color: .blue, radius: addTaskButtonShadowRadius)
                        }
                    }.padding(20)
                }
                .onAppear {
                    allTaskViewModel.loadFromFileCache()
                }
            }
            .navigationTitle("All task")
            Text("No Selection").font(.headline)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let allTasks = AllTask(items: AllItems(tasks: [TodoTask(text: "asd", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil), TodoTask(text: "asd", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil), TodoTask(text: "asd", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil), TodoTask(text: "asd", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil)], isLoad: true))
        AllTaskView(allTaskViewModel: allTasks)
    }
}
