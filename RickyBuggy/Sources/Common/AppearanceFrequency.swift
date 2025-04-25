//
//  AppearanceFrequency.swift
//  RickyBuggy
//

import Foundation


/// Level selected based on number of appearances in the show, if character appeared 10 times or more - it's high, if 3 times or more - its medium, if 1 or lower - it's low
enum AppearanceFrequency: Int {
    case high = 10
    case medium = 3
    case low = 1
}

extension AppearanceFrequency {
    init(count: Int) {
        switch count {
        case ..<1:
            self = .low
        case 2...3:
            self = .medium
        default:
            self = .high
        }
    }
    
    var popularity: String {
        switch self {
        case .high:
            return "So popular!"
        case .medium:
            return "Kind of popular"
        case .low:
            return "Meh"
        }
    }
}
