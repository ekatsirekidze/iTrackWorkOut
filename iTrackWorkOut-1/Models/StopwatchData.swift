//
//  StopwatchData.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 07.06.25.
//

import Foundation
import SwiftUI
import SwiftData


struct StopwatchData {
    var completionDate: Date
    var times: [Time]
    var taskId: UUID

    init(completionDate: Date, taskId: UUID, times: [Time]) {
        self.completionDate = completionDate
        self.taskId = taskId
        self.times = times
    }
    
    var totalInterval: TimeInterval {
        times.lazy.map { $0.interval }.reduce(0,+)
    }

}

struct Time {
    var start: Date
    var end: Date
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end

    }
    
    var interval: TimeInterval {
        start.distance(to: end)
    }
    
}
