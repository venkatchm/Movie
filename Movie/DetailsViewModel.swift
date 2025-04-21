//
//  DetailsViewModel.swift
//  Movie
//
//  Created by G Arthi on 25/02/25.
//

import Foundation

class DetailsViewModel: ObservableObject {
    
    @Published var similarMovies: [MovieData] = []
    
    func fetchSimilarMovies(movieId: Int) {
        
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    self.similarMovies = decodedResponse.results
                }
            } catch {
                print("Failed to fetch similar movies: \(error.localizedDescription)")
            }
        }
    }
}

