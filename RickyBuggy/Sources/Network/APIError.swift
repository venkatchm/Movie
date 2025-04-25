//
//  APIError.swift
//  RickyBuggy
//

import Foundation

enum APIError: Error {
    case imageDataRequestFailed
    case charactersRequestFailed
    case characterDetailRequestFailed
    case locationRequestFailed
    case invalidURL
    case customError(_ error: Error)
}

extension APIError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .imageDataRequestFailed:
            return "Could not download image"
        case .charactersRequestFailed:
            return "Could not fetch characters"
        case .characterDetailRequestFailed:
            return "Could not get details of character"
        case .locationRequestFailed:
            return "Could not get details of location"
        case .invalidURL:
            return "Invalid URL"
        case .customError(let error):
            return error.localizedDescription
        }
    }
}

extension APIError: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .imageDataRequestFailed:
            hasher.combine("imageDataRequestFailed")
        case .charactersRequestFailed:
            hasher.combine("charactersRequestFailed")
        case .characterDetailRequestFailed:
            hasher.combine("characterDetailRequestFailed")
        case .locationRequestFailed:
            hasher.combine("locationRequestFailed")
        case .invalidURL:
            hasher.combine("invalidURL")
        case .customError(let error):
            // Use the localizedDescription to generate a hash
            hasher.combine(error.localizedDescription)
        }
    }

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.imageDataRequestFailed, .imageDataRequestFailed),
            (.charactersRequestFailed, .charactersRequestFailed),
            (.characterDetailRequestFailed, .characterDetailRequestFailed),
            (.invalidURL, .invalidURL),
            (.locationRequestFailed, .locationRequestFailed):
            return true
        case (.customError(let lhsError), .customError(let rhsError)):
            // Compare the localized descriptions of the errors as a fallback
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
