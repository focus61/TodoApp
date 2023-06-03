//
//  AllTaskRow.swift
//  TodoApp
//
//  Created by Aleksandr on 31.05.2023.
//

import SwiftUI

struct AllTaskRow: View {
    var taskText: String
    var isDone: Bool
    var isOverdueDeadline: Bool
    ///unimportant = 0, normal = 1, important = 2
    var importantRow: Int
    var body: some View {
        HStack {
            let button = Button {
                print("SOME")
            } label: {
                ZStack {
                    Circle()
                        .fill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(
                            isDone ? .green : (isOverdueDeadline ? .red : .clear)
                        )
                        .cornerRadius(10)
                    if isDone {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.caption2)
                    }
                }
               
            }
            if !isDone && !isOverdueDeadline {
                button.overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                ).padding(5)
            }
            HStack {
                if importantRow == 0 {
                    Image(systemName: "arrow.down")
                } else if importantRow == 2 {
                    Image(systemName: "exclamationmark.2")
                }
                Text(taskText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3, reservesSpace: false)
                Spacer()
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            return 0
        }
    }
}

struct TodoItemRow_Previews: PreviewProvider {
    static var previews: some View {
        AllTaskRow(taskText: "Текст", isDone: false, isOverdueDeadline: false, importantRow: 2)
    }
}
