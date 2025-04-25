//
//  MovieService.swift
//  Movie
//
//  Created by G Arthi on 26/02/25.
//

import Foundation

struct MovieService {
    static let shared = MovieService() // Singleton instance

    func fetchMovies() async throws -> [MovieData] {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=3db46ae545bd903b1d5740b03deddfe1&language=en") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        
        do {
            let decodedResponse = try decoder.decode(MovieResponse.self, from: data)
            return decodedResponse.results
        } catch {
            throw error
        }
    }
}
