//
//  ProjectsView.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 18.05.25.
//

import SwiftUI

struct ProjectsView: View {
    var projects: [Project] = MockDataService.shared.getProjects()
    
    @State private var sortOrder = SortDescriptor(\Project.name)
    @State private var isSearching = false
    @State private var searchTerm = ""
    
    private var searchResults: [SearchResult] {
        var result: [Project: SearchResult] = [:]
        
        let lowercaseSearchTerm = searchTerm.localizedLowercase
        
        for project in projects {
            if project.name.localizedLowercase.contains(lowercaseSearchTerm) {
                result[project] = SearchResult(project: project, tasks: [], tags: [], findReasons: [.project])
            }
            for task in project.tasks {
                if task.name.localizedLowercase.contains(lowercaseSearchTerm) {
                    var sr = result[project] ?? SearchResult(project: project, tasks: [], tags: [], findReasons: [])
                    sr.tasks.insert(task)
                    sr.findReasons.insert(.task(task.id))
                    result[project] = sr
                }
                for tag in task.tags {
                    if tag.localizedLowercase.contains(lowercaseSearchTerm) {
                        var sr = result[project] ?? SearchResult(project: project, tasks: [], tags: [], findReasons: [])
                        sr.tasks.insert(task)
                        sr.tags.insert(tag)
                        sr.findReasons.insert(.tag(tag))
                        result[project] = sr
                    }
                }
            }
        }
        
        return Array(result.values)
    }
    
    var body: some View {
        NavigationStack {
            
            Group {
                if !isSearching {
                    if (projects.isEmpty) {
                        VStack {
                            Spacer()
                            Text("There are no projects.")
                            NavigationLink("Add new project") {
                                NewExerciseView()
                            }
                            Spacer()
                        }
                    }
                    
                    List {
                        ForEach(projects) { exercise in
                            NavigationLink(destination: ProjectContentView(exercise: exercise)) {
                                ExerciseCell(exercise: exercise)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                            }
                        }
                        .padding()
                        
                    }
                } else if searchTerm.isEmpty {
                    Text("Start typing to search")
                } else {
                    List(searchResults) { result in
                        NavigationLink {
                            ProjectContentView(exercise: result.project)
                        } label: {
                            ProjectSearchResultView(result: result)
                        }
                        
                    }
                }
            }
            .navigationTitle("Projects")
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: NewExerciseView()) {
                        Image(systemName: "plus")
                    }
            )
            .searchable(text: $searchTerm, isPresented: $isSearching)
        }
    }
}

struct ProjectSearchResultView: View {
    var result: SearchResult

    var body: some View {
        VStack(alignment: .leading) {
            projectTitleView

            ForEach(sortedTasks) { task in
                taskView(for: task)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var projectTitleView: some View {
        Group {
            if result.findReasons.contains(.project) {
                Text(result.project.name)
                    .foregroundStyle(Color.accentColor)
                    .font(.title)
            } else {
                Text(result.project.name)
                    .font(.title)
            }
        }
    }

    private var sortedTasks: [Task] {
        result.tasks.sorted { $0.id < $1.id }
    }

    @ViewBuilder
    private func taskView(for task: Task) -> some View {
        VStack(alignment: .leading) {
            if result.findReasons.contains(.task(task.id)) {
                Text("Task: \(task.name)")
                    .foregroundStyle(Color.accentColor)
            } else {
                Text("Task: \(task.name)")
            }

            let foundTags = task.tags.filter { result.tags.contains($0) }
            if !foundTags.isEmpty {
                tagView(for: foundTags)
            }
        }
        .padding([.leading])
    }

    @ViewBuilder
    private func tagView(for tags: [String]) -> some View {
        Group {
            Text("Tags: ")
            + Text(tags.joined(separator: ", "))
                .foregroundStyle(Color.accentColor)
        }
        .padding([.leading])
    }
}

struct SearchResult: Identifiable {
    var id: UUID = UUID()
    
    var project: Project
    var tasks: Set<Task>
    var tags: Set<String>
    var findReasons: Set<SearchResultFindReason>
}

enum SearchResultFindReason: Hashable {
    case project
    case task(UUID)
    case tag(String)
}

