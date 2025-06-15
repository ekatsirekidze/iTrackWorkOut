//
//  Settings.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 08.06.25.
//

import SwiftUI
import SwiftData

struct Settings: Codable {
    var firstName: String?
    var lastName: String?
    var email: String?
    var birthday: Date?
    var accentColor: AccentColor = .yellow
    var availableTags: [Tag] = []
    var notificationTime: HourAndMinute?
    var dynamicFontSize: CGFloat? = 14
    
    mutating func changeNotificationTime() {
        notificationTime = nil
    }
}

struct HourAndMinute: Codable {
    var hour: Int
    var minute: Int
}

enum AccentColor: Codable {
    case red
    case green
    case blue
    case yellow
    case purple
}

extension AccentColor {
    var string: String {
        switch self {
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .yellow:
            return "Yellow"
        case .purple:
            return "Purple"
        }
    }
    
    var swiftuiAccentColor: Color {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        }
    }
}
