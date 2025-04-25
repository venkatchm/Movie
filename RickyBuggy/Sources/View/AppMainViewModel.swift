//
//  AppMainViewModel.swift
//  RickyBuggy
//

import Combine
import Foundation

final class AppMainViewModel: ObservableObject {
    @Published var showsSortActionSheet: Bool = false
    @Published var sortMethod: SortMethod = .name
    @Published var characters: [CharacterResponseModel] = []

    @Published private(set) var characterErrors: [APIError] = []
    @Published private(set) var sortMethodDescription: String = "Choose Sorting"

    private let showsSortActionSheetSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let sortMethodSubject = CurrentValueSubject<SortMethod?, Never>(nil)

    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        sortMethodSubject
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] sortMethod in
                self?.sortMethod = sortMethod
                self?.sortMethodDescription = sortMethod.description
                self?.requestData()
            })
            .store(in: &cancellables)
        
        showsSortActionSheetSubject
            .compactMap { $0 }
            .assign(to: &$showsSortActionSheet)
        
        requestData()
    }
    
    func setSortMethod(_ sortMethod: SortMethod) {
        sortMethodSubject.send(sortMethod)
    }
    
    func setShowsSortActionSheet() {
        showsSortActionSheetSubject.send(true)
    }
    
    func requestData() {
        #if DEBUG
        debugPrint("Fetching data")
        #endif
        
        characterErrors.removeAll()

        isLoading = true

        let apiService = DIContainer.shared.resolve(APIClient.self)
        
        apiService?.charactersPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.characterErrors.append(error)
                case .finished:
                    break
                }
                
                self?.isLoading = false
            }, receiveValue: { [weak self] characters in
                switch self?.sortMethod {
                case .name:
                    self?.characters = characters.sorted(by: {$0.name < $1.name})
                case .episodesCount:
                    self?.characters = characters.sorted(by: {$0.episode.count > $1.episode.count})
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
}
