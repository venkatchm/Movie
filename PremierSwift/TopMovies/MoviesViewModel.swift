import Foundation

enum MoviesViewModelState {
    case loading
    case loaded([Movie])
    case error

    var movies: [Movie] {
        switch self {
        case .loaded(let movies):
            return movies
        case .loading, .error:
            return []
        }
    }
}

final class MoviesViewModel {

    private let apiManager: APIManaging

    init(apiManager: APIManaging = APIManager()) {
        self.apiManager = apiManager
    }

    var updatedState: (() -> Void)?

    var state: MoviesViewModelState = .loading {
        didSet {
            updatedState?()
        }
    }

    func fetchData() {
        apiManager.execute(Movie.topRated) { [weak self] result in
            switch result {
            case .success(let page):
                self?.state = .loaded(page.results)
            case .failure:
                self?.state = .error
            }
        }
    }

    func getSearchResults(for searchTerm: String, completion: @escaping ([Movie]) -> Void) {
        let request = Request<Page<Movie>>(method: Method.get, path: "/search/movie", pars: ["query": searchTerm])
        apiManager.execute(request, completion: { result in
            if case .success(let page) = result {
                completion(page.results)
            }
        })
    }
}
