//
//  Project.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 20.05.25.
//

import Foundation

struct Project: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var tasks: [Task]
    var startDate: Date
    var priority: Int
    
    init(id: UUID = UUID(), name: String, tasks: [Task] = [], startDate: Date, priority: Int = 2) {
        self.id = id
        self.name = name
        self.tasks = tasks
        self.startDate = startDate
        self.priority = priority
    }
}

struct Task: Identifiable, Hashable, Codable {
    var id: UUID
    
    var name: String
    var tags: [String]
    var startDate: Date
    var priority: Int
    var repeatDays: Set<DayOfWeek>
    
    init(id: UUID = UUID(), name: String, tags: [String] = [], startDate: Date, priority: Int = 2, repeatDays: Set<DayOfWeek> = Set()) {
        self.id = id
        self.name = name
        self.tags = tags
        self.startDate = startDate
        self.priority = priority
        self.repeatDays = repeatDays
    }
}


enum DayOfWeek: Int, Codable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    static let all: [DayOfWeek] = [
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday,
        .sunday,
    ]
}

extension DayOfWeek: Identifiable {
    var id: Int { self.rawValue }
}

extension DayOfWeek {
    var string : String {
        switch (self) {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
    var shortString : String {
        let longString = self.string
        return String(longString[longString.startIndex..<longString.index(longString.startIndex, offsetBy: 3)])
    }
}

