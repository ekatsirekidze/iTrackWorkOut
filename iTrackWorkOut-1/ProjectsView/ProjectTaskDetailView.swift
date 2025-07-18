//
//  ProjectTaskDetailView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 22.05.25.
//

import SwiftUI

struct ProjectTaskDetailView: View {
    var project: Project
    var task: ProjectTask
    @State private var name: String = ""
    var body: some View {
        Form {
            
            Section(header: Text("Time")) {
                Text(task.startDate, style: .date)
            }
            
            
            Section(header: Text("Priority")) {
                Text("Priority:  \(task.priority)")
            }
            
            Section(header: Text("Repeat")) {
                ForEach(Array(task.repeatDays.sorted { $0.rawValue < $1.rawValue }), id: \.rawValue) {day in
                    Text(day.string)
                }
            }
            
            Section(header: Text("Tags")) {
                ForEach(task.tags, id: \.self) { tag in
                    Text(tag)
                }
            }
            

        }
        .navigationBarTitle(task.name)
        
    }
}

