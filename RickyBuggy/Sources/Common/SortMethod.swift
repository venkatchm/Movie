//
//  SortMethod.swift
//  RickyBuggy
//

enum SortMethod: Int {
    case name
    case episodesCount
}

extension SortMethod: CustomStringConvertible {
    var description: String {
        switch self {
        case .name:
            return "Name"
        case .episodesCount:
            return "Episodes Count"
        }
    }
}
