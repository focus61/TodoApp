//
//  TaskDetailView.swift
//  TodoApp
//
//  Created by Aleksandr on 01.06.2023.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var viewModel: DetailTask
    private let cornerRadius: CGFloat = 10
    @State private var isShowCalendar: Bool = false
    private var deadlineDate: Date? {
        if isShowCalendar && viewModel.isDeadlineOn {
            return viewModel.selectedDateInCalendar
        }
        return nil
    }
    init(viewModel: DetailTask) {
        self.viewModel = viewModel
    }
    var body: some View {
            ZStack {
                Color(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)).ignoresSafeArea()
                ScrollView {
                    VStack {
                        TextEditor(text: $viewModel.text)
                            .frame(height: 150)
                            .cornerRadius(cornerRadius)
                            .clipped()
                            .foregroundColor(.gray)
                            .offset()
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(cornerRadius)
                            VStack {
                                HStack {
                                    Text("Важность")
                                    Spacer()
                                    Picker("important", selection: $viewModel.importantIndex) {
                                        Image(systemName: "arrow.down").tag(0)
                                        Text("нет").tag(1)
                                        Image(systemName: "exclamationmark.2").tag(2)
                                    }
                                    .frame(width: 150)
                                    .pickerStyle(.segmented)
                                }
                                Divider()
                                HStack {
                                    Toggle(isOn: $viewModel.isDeadlineOn) {
                                        if viewModel.isDeadlineOn {
                                            VStack(alignment: .leading) {
                                                Text("Сделать до")
                                                Button {
                                                    isShowCalendar.toggle()
                                                } label: {
                                                    Text(viewModel.dateToString()).font(.subheadline)
                                                }
                                            }
                                        } else {
                                            Text("Сделать до")
                                        }
                                    }
                                }
                                if isShowCalendar {
                                    VStack {
                                        Divider()
                                        DatePicker("DatePicker", selection: $viewModel.selectedDateInCalendar, displayedComponents: .date)
                                        .datePickerStyle(.graphical)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 50)
                            .foregroundColor(.white)
                        Button {
                            viewModel.deleteTask(by: viewModel.taskUUID)
                        } label: {
                            Text("Delete").foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                Button {
                    viewModel.changeTask(deadline: deadlineDate)
                    viewModel.saveTask()
                } label: {
                    Text("Save")
                }
            }
            .navigationTitle("Task")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DetailTask(model: TodoTask(text: "щуащаощ", deadline: nil, isDone: true, dateСreation: Date(), dateChange: nil), fileCache: FileCache())
        TaskDetailView(viewModel: viewModel)
    }
}
