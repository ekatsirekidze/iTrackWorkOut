////
////  MockDataService.swift
////  iTrackWorkOut-1
////
////  Created by X34 on 04.06.25.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//class MockDataService {
//    static let shared = MockDataService()
//    
//    let db = Firestore.firestore()
//    
//    let uid: String
//    
//    private init() {
//        if let user = Auth.auth().currentUser {
//            uid = user.uid
//        } else { uid = "" }
//    }
//    
//    func getProjects() -> [Project] {
//       []
//    }
//    
//    func getStopwatchData() -> [StopwatchData] {
//    
//        let calendar = Calendar(identifier: .gregorian)
//
//        let now =
//                Calendar(identifier: .gregorian).date(from: DateComponents(year: 2025, month: 7, day: 1, hour: 12, minute: 0))!
//        
//        return []
//        }
//    
//    func getTags() -> [Tag] {
//        []
//    }
//    
//    func saveTag(tag: Tag) {
//        
//    }
//    
//    func saveExercise(project: Project) {
//        // TODO: save exercise to database
//    }
//    
//    func addNewTask(to project: Project, task: Task) {
//        // TODO: update project to database( add new task in projects)
//    }
//    
//    func getSettings() -> [Settings] {
//        []
//    }
//    
//    func deleteTask(task: Task, project: Project) {
//        // TODO: delete task from conrete project
//    }
//    
//    func updateSettings(with settings: Settings) {
//        // TODO: this func will update settings in future
//    }
//    
//    func updateStopWatchData(with stopwatchData: StopwatchData) {
//        // TODO: this func will update settings in future
//    }
//}




//
//  MockDataService.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 04.06.25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class MockDataService {
    static let shared = MockDataService()
    
    let db = Firestore.firestore()
    
    let uid: String
    
    private init() {
        if let user = Auth.auth().currentUser {
            uid = user.uid
        } else {
            uid = ""
        }
    }

    // MARK: - PROJECTS
    
    @MainActor
    func getProjects() async throws -> [Project] {
        guard !uid.isEmpty else { return [] }
        
        let snapshot = try await db.collection("users").document(uid)
            .collection("projects")
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Project.self)
        }
    }
    
    @MainActor
    func saveExercise(project: Project) async throws {
        guard !uid.isEmpty else { return }

        try await db.collection("users").document(uid)
            .collection("projects").document(project.id.uuidString)
            .setData(from: project)
    }

    func addNewTask(to project: Project, task: ProjectTask) {
        Task {
            guard !uid.isEmpty else { return }
            
            var updatedProject = project
            //updatedProject.tasks.append(task)
            
            do {
                try await updateProject(project: updatedProject)
            } catch {
                print("Failed to update project with new task: \(error)")
            }
        }
    }
    
    @MainActor
    func updateProject(project: Project) async throws {
        guard !uid.isEmpty else { return }
        
        try db.collection("users")
            .document(uid)
            .collection("projects")
            .document(project.id.uuidString)
            .setData(from: project, merge: true) // merge:true preserves existing fields unless overwritten
    }

    func deleteProject(_ project: Project) {
        Task {
            guard !uid.isEmpty else { return }
            
            do {
                try await db.collection("users")
                    .document(uid)
                    .collection("projects")
                    .document(project.id.uuidString)
                    .delete()
            } catch {
                print("Error deleting project: \(error.localizedDescription)")
            }
        }
    }


    func deleteTask(task: ProjectTask, project: Project) {
        guard !uid.isEmpty else { return }

        var updatedProject = project
        updatedProject.tasks.removeAll { $0.id == task.id }
        let updatedConstantProject = updatedProject

        Task {
            try await saveExercise(project: updatedConstantProject)
        }
    }

    // MARK: - TAGS

    func getTags() async -> [Tag] {
       
        var tags: [Tag] = []
        guard !uid.isEmpty else { return tags }

        let semaphore = DispatchSemaphore(value: 0)

        db.collection("users").document(uid)
            .collection("tags")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tags: \(error)")
                } else {
                    tags = snapshot?.documents.compactMap {
                        try? $0.data(as: Tag.self)
                    } ?? []
                }
                semaphore.signal()
            }

        semaphore.wait()
        return tags
    }

    func saveTag(tag: Tag) {
        Task {
            guard !uid.isEmpty else { return }
            
            do {
                try db.collection("users").document(uid)
                    .collection("tags").document(tag.id.uuidString)
                    .setData(from: tag)
            } catch {
                print("Error saving tag: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - SETTINGS

    func getSettings() async -> [Settings] {
        var settingsList: [Settings] = []
        guard !uid.isEmpty else { return settingsList }

        let semaphore = DispatchSemaphore(value: 0)

        db.collection("users").document(uid)
            .collection("settings")
            .document("main")
            .getDocument { snapshot, error in
                if let snapshot = snapshot,
                   let settings = try? snapshot.data(as: Settings.self) {
                    settingsList = [settings]
                } else {
                    print("Error fetching settings or no data.")
                }
                semaphore.signal()
            }

        semaphore.wait()
        return settingsList
    }

    func updateSettings(with settings: Settings) {
        Task {
            guard !uid.isEmpty else { return }
            
            do {
                try db.collection("users").document(uid)
                    .collection("settings").document("main")
                    .setData(from: settings)
            } catch {
                print("Error saving settings: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - STOPWATCH DATA

    func getStopwatchData() async -> [StopwatchData] {
        var stopwatchList: [StopwatchData] = []
        guard !uid.isEmpty else { return stopwatchList }

        let semaphore = DispatchSemaphore(value: 0)

        db.collection("users").document(uid)
            .collection("stopwatchData")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching stopwatch data: \(error)")
                } else {
                    stopwatchList = snapshot?.documents.compactMap {
                        try? $0.data(as: StopwatchData.self)
                    } ?? []
                }
                semaphore.signal()
            }

        semaphore.wait()
        return stopwatchList
    }

    func updateStopWatchData(with stopwatchData: StopwatchData) {
        Task {
            guard !uid.isEmpty else { return }
            
            do {
                try db.collection("users").document(uid)
                    .collection("stopwatchData")
                    .addDocument(from: stopwatchData)
            } catch {
                print("Error saving stopwatch data: \(error.localizedDescription)")
            }
        }
    }
}



































//
//import Foundation
//import Firebase
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import FirebaseAuth
//
//class MockDataService {
//    static let shared = MockDataService()
//    
//    private let db = Firestore.firestore()
//    private let uid: String
//    
//    private init() {
//        if let user = Auth.auth().currentUser {
//            uid = user.uid
//        } else {
//            uid = ""
//        }
//    }
//
//    // MARK: - PROJECTS
//    
//    @MainActor
//    func getProjects() async throws -> [Project] {
//        guard !uid.isEmpty else { return [] }
//
//        let snapshot = try await db.collection("users").document(uid).collection("projects").getDocuments()
//        return snapshot.documents.compactMap { try? $0.data(as: Project.self) }
//    }
//
//    @MainActor
//    func saveExercise(project: Project) async throws {
//        guard !uid.isEmpty else { return }
//        try db.collection("users").document(uid)
//            .collection("projects")
//            .document(project.id.uuidString)
//            .setData(from: project)
//    }
//
//    func addNewTask(to project: Project, task: ProjectTask) {
//        Task {
//            guard !uid.isEmpty else { return }
//
//            var updatedProject = project
//            updatedProject.tasks.append(task)
//
//            do {
//                try await saveExercise(project: updatedProject)
//            } catch {
//                print("Failed to update project with new task: \(error)")
//            }
//        }
//    }
//
//    func deleteTask(task: ProjectTask, from project: Project) {
//        Task {
//            guard !uid.isEmpty else { return }
//
//            var updatedProject = project
//            updatedProject.tasks.removeAll { $0.id == task.id }
//
//            do {
//                try await saveExercise(project: updatedProject)
//            } catch {
//                print("Error deleting task: \(error)")
//            }
//        }
//    }
//
//    // MARK: - TAGS
//
//    func getTags() async -> [Tag] {
//        guard !uid.isEmpty else { return [] }
//
//        do {
//            let snapshot = try await db.collection("users").document(uid).collection("tags").getDocuments()
//            return snapshot.documents.compactMap { try? $0.data(as: Tag.self) }
//        } catch {
//            print("Error fetching tags: \(error)")
//            return []
//        }
//    }
//
//    func saveTag(tag: Tag) {
//        Task {
//            guard !uid.isEmpty else { return }
//
//            do {
//                try db.collection("users").document(uid)
//                    .collection("tags")
//                    .document(tag.id.uuidString)
//                    .setData(from: tag)
//            } catch {
//                print("Error saving tag: \(error)")
//            }
//        }
//    }
//
//    // MARK: - SETTINGS
//
//    func getSettings() async -> Settings? {
//        guard !uid.isEmpty else { return nil }
//
//        do {
//            let doc = try await db.collection("users").document(uid).collection("settings").document("main").getDocument()
//            return try doc.data(as: Settings.self)
//        } catch {
//            print("Error fetching settings: \(error)")
//            return nil
//        }
//    }
//
//    func updateSettings(with settings: Settings) {
//        Task {
//            guard !uid.isEmpty else { return }
//
//            do {
//                try db.collection("users").document(uid)
//                    .collection("settings")
//                    .document("main")
//                    .setData(from: settings)
//            } catch {
//                print("Error updating settings: \(error)")
//            }
//        }
//    }
//
//    // MARK: - STOPWATCH DATA
//
//    func getStopwatchData() async -> [StopwatchData] {
//        guard !uid.isEmpty else { return [] }
//
//        do {
//            let snapshot = try await db.collection("users").document(uid).collection("stopwatchData").getDocuments()
//            return snapshot.documents.compactMap { try? $0.data(as: StopwatchData.self) }
//        } catch {
//            print("Error fetching stopwatch data: \(error)")
//            return []
//        }
//    }
//
//    func updateStopWatchData(with stopwatchData: StopwatchData) {
//        Task {
//            guard !uid.isEmpty else { return }
//
//            do {
//                try db.collection("users").document(uid)
//                    .collection("stopwatchData")
//                    .addDocument(from: stopwatchData)
//            } catch {
//                print("Error updating stopwatch data: \(error)")
//            }
//        }
//    }
//}
