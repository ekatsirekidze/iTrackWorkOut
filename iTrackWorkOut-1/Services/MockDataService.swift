//
//  MockDataService.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 04.06.25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MockDataService {
    static let shared = MockDataService()
    
    let db = Firestore.firestore()
    
    let uid: String
    
    private init() {
        if let user = Auth.auth().currentUser {
            uid = user.uid
        } else { uid = "" }
    }
    
    func getProjects() -> [Project] {
        let calendar = Calendar(identifier: .gregorian)
        let baseDate = calendar.date(from: DateComponents(year: 2025, month: 5, day: 20))!

        let task1 = Task(
            name: "Upper Body Workout",
            tags: ["strength", "gym"],
            startDate: calendar.date(byAdding: .day, value: 1, to: baseDate)!,
            priority: 1,
            repeatDays: [.monday, .wednesday, .friday]
        )
        
        let task2 = Task(
            name: "Cardio Session",
            tags: ["cardio", "run"],
            startDate: calendar.date(byAdding: .day, value: 2, to: baseDate)!,
            priority: 2,
            repeatDays: [.tuesday, .thursday]
        )
        
        let task3 = Task(
            name: "Yoga & Stretching",
            tags: ["yoga", "flexibility"],
            startDate: calendar.date(byAdding: .day, value: 3, to: baseDate)!,
            priority: 3,
            repeatDays: [.saturday, .sunday]
        )
        
        let project1 = Project(
            name: "Full Body Fitness Plan",
            tasks: [task1, task2],
            startDate: baseDate,
            priority: 1
        )
        
        let project2 = Project(
            name: "Flexibility Improvement",
            tasks: [task3],
            startDate: calendar.date(byAdding: .day, value: 5, to: baseDate)!,
            priority: 2
        )
        
        let project3 = Project(
            name: "General Health Routine",
            tasks: [],
            startDate: calendar.date(byAdding: .day, value: 7, to: baseDate)!,
            priority: 3
        )

        return [project1, project2, project3]
    }
    
    func getStopwatchData() -> [StopwatchData] {
    
        let calendar = Calendar(identifier: .gregorian)

        let now =
                Calendar(identifier: .gregorian).date(from: DateComponents(year: 2025, month: 7, day: 1, hour: 12, minute: 0))!
        let stopwatchData =
         [
                StopwatchData(
                    completionDate: calendar.date(byAdding: .day, value: -1, to: now)!,
                    taskId: UUID(),
                    times: [
                        createTime(startOffset: -3600, duration: 1200), // 20 min
                        createTime(startOffset: -1800, duration: 600)   // 10 min
                    ]
                ),
                StopwatchData(
                    completionDate: calendar.date(byAdding: .day, value: -2, to: now)!,
                    taskId: UUID(),
                    times: [
                        createTime(startOffset: -7200, duration: 1800), // 30 min
                        createTime(startOffset: -3600, duration: 900)   // 15 min
                    ]
                ),
                StopwatchData(
                    completionDate: calendar.date(byAdding: .day, value: -3, to: now)!,
                    taskId: UUID(),
                    times: [
                        createTime(startOffset: -10800, duration: 600), // 10 min
                        createTime(startOffset: -5400, duration: 1200)  // 20 min
                    ]
                )
            ]
        return stopwatchData
    }
    
    func getTags() -> [Tag] {
        let tags = [
            Tag(name: "homeworkout"),
            Tag(name: "gym"),
            Tag(name: "cardio")
        ]
        
        return tags
    }
    
    func saveExercise(project: Project) {
        // TODO: save exercise to database
    }
    
    func getSettings() -> [Settings] {
        [
            .init(
                firstName: "Eka",
                lastName: "Tsirekidze",
                email: "ekatsirekidze@gmail.com",
                birthday: .init(),
                notificationTime: .init(
                    hour: 10,
                    minute: 10
                )
            )
        ]
    }
    
    func updateSettings(with settings: Settings) {
        // TODO: this func will update settings in future
    }
    
    private func createTime(startOffset: TimeInterval, duration: TimeInterval) -> Time {
        let now =
                Calendar(identifier: .gregorian).date(from: DateComponents(year: 2025, month: 7, day: 1, hour: 12, minute: 0))!
        let start = now.addingTimeInterval(startOffset)
        let end = start.addingTimeInterval(duration)
        return Time(start: start, end: end)
    }
    
    func updateStopWatchData(with stopwatchData: StopwatchData) {
        // TODO: this func will update settings in future
    }
}
