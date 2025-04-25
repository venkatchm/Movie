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
        
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=3db46ae545bd903b1d5740b03deddfe1&language=en"
        
        guard let url = URL(string: "urlString") else { return }
        
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

