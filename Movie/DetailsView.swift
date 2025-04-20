
import SwiftUI

//struct DetailsViewViewBuidler<Content: View>: View {
//        
//}

struct DetailsView: View {
    let movie: MovieData
    @StateObject private var viewModel = DetailsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MovieImageView(posterPath: movie.posterPath)
                
                MovieTitleView(title: movie.title ?? movie.originalTitle)
                
                //                MovieReleaseDateView(releaseDate: movie.releaseDate)
                releaseDateView
                //                MovieOverviewView(overview: movie.overview)
                overView
                Text("title_similar_movies")
                    .font(.headline)
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.similarMovies) { similarMovie in
                            SimilarMovieCard(movie: similarMovie)
                        }
                    }
                    .padding(.horizontal)
                }
              
            }
            .padding()
        }
        .navigationTitle("navigation_title_movie_details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchSimilarMovies(movieId: movie.id)
        }
        
        
    }
    
   @ViewBuilder
    var releaseDateView: some View {
        if let releaseDate = movie.releaseDate {
            Text("text_release_date \(releaseDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    var overView: some View {
        Text(movie.overview)
            .font(.body)
            .multilineTextAlignment(.leading)
            .padding()
    }
}
struct MovieImageView: View {
    let posterPath: String?

    var body: some View {
        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
                .cornerRadius(10)
                .shadow(radius: 5)
        } placeholder: {
            ProgressView()
        }
        .frame(height: 450) // Adjust height to keep consistent aspect ratio
        .frame(maxWidth: .infinity, alignment: .center)
    }
       
}

struct MovieTitleView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}




//struct MovieReleaseDateView: View {
//    let releaseDate: String?
//
//    var body: some View {
//        if let releaseDate = releaseDate {
//            Text("Release Date: \(releaseDate)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .frame(maxWidth: .infinity, alignment: .center)
//        }
//    }
//}
//
//
//struct MovieOverviewView: View {
//    let overview: String
//
//    var body: some View {
//        Text(overview)
//            .font(.body)
//            .multilineTextAlignment(.leading)
//            .padding()
//    }
//}
struct SimilarMovieCard: View {
    let movie: MovieData

    var body: some View {
        VStack {
            MovieImageView(posterPath: movie.posterPath)
                .frame(width: 120, height: 180)
                .cornerRadius(8)

            Text(movie.title ?? movie.originalTitle)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 120)
            
            Text("text_rating \(movie.popularity)")
                .font(.caption)
                .foregroundStyle(.gray)
            
        }
    }
}




#Preview {
    DetailsView(movie: MovieData(
        id: 1,
        title: "Inception",
        originalTitle: "Inception",
        originalLanguage: "en",
        adult: false,
        overview: "A mind-bending thriller by Christopher Nolan.",
        posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
        releaseDate: "2010-07-16",
        popularity: 234.2
    ))
}






