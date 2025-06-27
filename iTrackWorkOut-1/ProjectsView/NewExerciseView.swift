//
//  NewExerciseView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 24.06.25.
//

import SwiftUI

struct NewExerciseView: View {
    
    @State var existingProjects: [Project] = []
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Project Name".localized)) {
                    TextField("", text: $name)
                    if existingProjects.contains(where: { $0.name.localizedLowercase == name.localizedLowercase }) {
                        Text("A project with the same name already exists".localized).foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationBarTitle("New Project")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel".localized) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save".localized) {
                    let exercise = Project(name: name, startDate: .now, priority: 2)
                    MockDataService.shared.saveExercise(project: exercise)
                }
                .disabled(name.isEmpty || existingProjects.contains(where: { $0.name.localizedLowercase == name.localizedLowercase }))
            }
        }
        .onAppear {
            existingProjects = MockDataService.shared.getProjects()
        }
    }
}

