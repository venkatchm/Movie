import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var isError: Bool = false

    var body: some View {
        NavigationStack  {
            ScrollView {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(destination: DetailsView(movie: movie)) {
                        MovieRowView(movie: movie)
                    }
                }
            }.padding()
//            List(viewModel.movies, id: \.title) { movie in
//                NavigationLink(destination: DetailsView(movie: movie)) {
//                    MovieRowView(movie: movie)
//                }
//            }
                .task {
                    await viewModel.fetchMovies()
                    if viewModel.errorMessage != nil {
                        isError = true
                    }
                }
                .alert("alert_fetching_failed", isPresented: $isError) {
                    Button("exception_button_ok", role: .cancel) { }
                } message: {
                    Text(viewModel.errorMessage ?? "An unknown error occurred.")
                }
           
            .navigationTitle("navigation_title_movies")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

// Main Thread, background thread, utility

// Main Executer and Global Executer




struct MovieRowView: View {
    let movie: MovieData //Data

    var body: some View {
        HStack {
            MoviePosterView(posterPath: movie.posterPath)
            Spacer()
            VStack(alignment: .leading) {
                Text(movie.title ?? movie.originalTitle)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(movie.overview)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
    }
}


//MovieRowView() {
//    VStack(alignment: .leading) {
//        Text(movie.title ?? movie.originalTitle)
//            .font(.headline)
//            .foregroundColor(.black)
//        Text(movie.overview)
//            .font(.subheadline)
//            .lineLimit(2)
//            .foregroundColor(.gray)
//            .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}

struct MoviePosterView: View {
    let posterPath: String?

    var body: some View {
        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")) { image in
            image
                .resizable()

        }placeholder: {
            ProgressView()
            //Text("Loading View")
        }
        .frame(width: 100, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ContentView()
}
