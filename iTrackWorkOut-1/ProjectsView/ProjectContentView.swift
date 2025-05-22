//
//  ProjectContentView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 20.05.25.
//


import SwiftUI

struct ProjectContentView: View {
    
    var exercise: Project
    @State private var isEditing = false
    @State private var selection = Set<UUID>()
    
    @State private var deleteDialogVisible = false
    @State private var moveDialogVisible = false
    
    
    var body: some View {
        NavigationStack {
            if (exercise.tasks.isEmpty) {
                VStack {
                    Spacer()
                    Text("There are no tasks.")
                    NavigationLink("Add new task") {
                        Text("New Task")
                    }
                    Spacer()
                }
            }
            
            List(exercise.tasks, selection: $selection) { task in
                NavigationLink(destination: ProjectTaskDetailView(project:exercise, task: task)) {
                    Text(task.name)
                }
            }
            
        }
        .navigationTitle(exercise.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    
                    Button {
                        deleteDialogVisible = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .disabled(selection.isEmpty)
                    .confirmationDialog(
                        "Are you sure you want to delete \(selection.count) tasks?",
                        isPresented: $deleteDialogVisible,
                        titleVisibility: .visible
                    ) {
                        Button("Delete", role: .destructive) {
                        }
                    }
                    
                    Button {
                        moveDialogVisible = true
                    } label: {
                        Text("Move")
                    }
                    .disabled(selection.isEmpty)
                    .sheet(
                        isPresented: $moveDialogVisible
                    ) {
                        ChooseProjectView(title: "Choose Project", projects: []){_ in }
                        
                    }
                }
            }
        }
    }
}

struct ChooseProjectView: View {
    var title: String
    
    var projects: [Project]
    var onProjectChosen: (Project?) -> ()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text(title)
            .font(.title)
            .padding()
        
        List(projects) { project in
            Button {
                dismiss()
                onProjectChosen(project)
            } label: {
                Text(project.name)
            }
        }
    }
}
