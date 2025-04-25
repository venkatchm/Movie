//
//  Movie.swift
//  Movie
//
//  Created by G Arthi on 21/02/25.
//

import Foundation

struct MovieResponse: Codable {
    let results: [MovieData]
}
struct MovieData: Codable,Identifiable {
    var id:Int
    var title: String?
    var originalTitle:String
    var originalLanguage:String
    var adult:Bool
    var overview:String
    var posterPath:String?
    var releaseDate:String?
    var popularity:Float
   
    enum CodingKeys: String, CodingKey { // Primary way of doing conversation from snake case to camelCase
        case releaseDate = "release_date"
        case id
        case title
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case adult
        case overview
        case posterPath = "poster_path"
        case popularity
    }
    
}
