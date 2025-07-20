//
//  ProjectContentView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 20.05.25.
//


import SwiftUI

struct ProjectContentView: View {
    
    @State var exercise: Project
    @State private var isEditing = false
    @State private var selection = Set<UUID>()
    
    @State private var deleteDialogVisible = false
    @State private var moveDialogVisible = false
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        NavigationStack {
            if (exercise.tasks.isEmpty) {
                VStack {
                    Spacer()
                    Text("There are no tasks.")
                    NavigationLink("Add new task") {
                        NewTaskView(exercise: exercise) { project in
                            
                            let pj = project
                            self.exercise = pj
                        }
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
                    if editMode!.wrappedValue == .inactive {
                        NavigationLink(destination: NewTaskView(exercise: exercise) { project in
                            
                            let pj = project
                            exercise = pj
                        })
 {
                            Image(systemName: "plus")
                        }
                    } else {
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
                                let tasksToDelete = exercise.tasks.filter { selection.contains($0.id) }
                                exercise.tasks.removeAll { selection.contains($0.id) }
                                for task in tasksToDelete {
                                    MockDataService.shared.deleteTask(task: task, project: exercise)
                                }
                                selection.removeAll()
                            }
                        }
                        
                        Button {
                            moveDialogVisible = true
                        } label: {
                            Text("Move".localized)
                        }
                        .disabled(selection.isEmpty)
                        .sheet(
                            isPresented: $moveDialogVisible
                        ) {
                            ChooseProjectView(title: "Choose Project".localized) { newProject in
                                guard var newProject = newProject else { return }
                                let tasksToMove = exercise.tasks.filter { selection.contains($0.id) }
                                exercise.tasks.removeAll { selection.contains($0.id) }
                                newProject.tasks.append(contentsOf: tasksToMove)
                                selection.removeAll()
                            }
                        }
                    }
                    EditButton()
                }
            }
        }.onAppear()
    }
}

struct ChooseProjectView: View {
    var title: String
    
    @State var projects: [Project] = []
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
        .task {
            do {
                projects = try await MockDataService.shared.getProjects()
            } catch {
                
            }
        }
    }
}
