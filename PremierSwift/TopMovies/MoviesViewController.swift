import UIKit
import Combine

final class MoviesViewController: UITableViewController, UISearchResultsUpdating {
    
    private let viewModel: MoviesViewModel

    let cancellables: [AnyCancellable] = []
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let searchViewController = UISearchController(searchResultsController: SearchResultsViewController())
//    let timer =  Timer

    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedString(key: "movies.title")

        NotificationCenter.default.addObserver(self, selector: #selector(textSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)

        configureSearchBar()

        configureTableView()
        updateFromViewModel()
        bindViewModel()
        viewModel.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchViewController.searchResultsUpdater = self

        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    var updatedSearchText = ""
    var isAPIInProgress = false
    // Add a delay
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
//        guard searchText.count > 3 else {
//            return
//        }
        
        guard !searchText.isEmpty else {
            return
        }
        
        // GO
        // during in progress i typed D
        // So I need to make another api call to fetch result for GOD
        
        
        self.updatedSearchText = searchText
        guard !isAPIInProgress else {
            return
        }

        getSearchResults(searchText, searchController: searchController)
    }

    // Recursive function
    func getSearchResults(_ text: String, searchController: UISearchController) {
        guard !isAPIInProgress else {
            return
        }
        isAPIInProgress = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            print("getSearchResults \(text)")
            self?.viewModel.getSearchResults(for: text, completion: { results in
                DispatchQueue.main.async {
                    (searchController.searchResultsController as! SearchResultsViewController).movies = results
                    self?.isAPIInProgress = false
                    if text != self?.updatedSearchText {
                        self?.getSearchResults(self?.updatedSearchText ?? "", searchController: searchController)
                    }
                }
            })
        })
    }
    
    
    private func configureTableView() {
        tableView.dm_registerClassWithDefaultIdentifier(cellClass: MovieCell.self)
        tableView.rowHeight = UITableView.automaticDimension

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func bindViewModel() {
        viewModel.updatedState = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateFromViewModel()
            }
        }
    }

    private func updateFromViewModel() {
        switch viewModel.state {
        case .loading, .loaded:
            tableView.reloadData()
        case .error:
            showError()
        }
        refreshControl?.endRefreshing()
    }

    private func showError() {
        let alertController = UIAlertController(title: "", message: LocalizedString(key: "movies.load.error.body"), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: LocalizedString(key: "movies.load.error.actionButton"), style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc private func refreshData() {
        viewModel.fetchData()
    }

    @objc private func textSizeChanged() {
        tableView.reloadData()
    }

    private func configureSearchBar() {

        let searchTextField = searchViewController.searchBar.searchTextField
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.font: UIFont.Body.medium, .foregroundColor: UIColor.Text.charcoal])
        searchTextField.font = UIFont(name: "Poppins-Regular", size: 16)
        searchTextField.backgroundColor = UIColor(red: 248 / 255.0, green: 248 / 255.0, blue: 248 / 255.0, alpha: 1)
        searchTextField.borderStyle = .none
        searchTextField.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.cornerRadius = 8

        searchViewController.searchBar.setLeftImage(UIImage(named: "Search"))
        searchViewController.searchBar.barTintColor = .clear
        searchViewController.searchBar.setImage(UIImage(named: "Filter"), for: .bookmark, state: .normal)
        searchViewController.searchBar.showsBookmarkButton = true
        searchViewController.searchBar.delegate = self
        searchViewController.searchBar.tintColor = UIColor.Brand.popsicle40
    }
}

// MARK: - UITableViewDataSource
extension MoviesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()

        let movie = viewModel.state.movies[indexPath.row]
        cell.configure(movie)

        return cell
    }

}

// MARK: - UITableViewControllerDelegate
extension MoviesViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.state.movies[indexPath.row]
        let viewModel = MoviesDetailsViewModel(movie: movie, apiManager: APIManager())
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
