//
//  ContentView-ViewModel.swift
//  Movie
//
//  Created by G Arthi on 24/02/25.
//

import Foundation

///services
///
import Foundation

extension ContentView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var movies: [MovieData] = []
        @Published var errorMessage: String?

        func fetchMovies() async {
            do {
                self.movies = try await MovieService.shared.fetchMovies()
            }
            catch {
                self.errorMessage = "Failed to fetch movies: \(error.localizedDescription)"
            }
        }
    }
}



//File name for extension should be ContentView+ViewModel
//Use StateObject.

// State, Stateobject, ObservedObject

