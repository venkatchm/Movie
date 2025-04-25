//
//  CharactersListItemViewModel.swift
//  RickyBuggy
//

import Combine
import Foundation

final class CharactersListItemViewModel: ObservableObject {

    @Published private(set) var characterErrors: [APIError] = []

    @Published private(set) var title: String = "-"
    @Published private(set) var characterImageData: Data?
    @Published private(set) var created: String = "-"
    @Published private(set) var url: String = "-"

    private let characterSubject = CurrentValueSubject<CharacterResponseModel?, Never>(nil)

    private var cancellables = Set<AnyCancellable>()
    
    init(character: CharacterResponseModel) {
        let apiService = DIContainer.shared.resolve(APIClient.self)
        let characterSharedPublisher = characterSubject
            .compactMap { $0 }
            .share()
        
        characterSharedPublisher
            .map(\.name)
            .assign(to: &$title)
        
        characterSharedPublisher
            .map(\.image)
            .flatMap { imageURLString -> ImageDataPublisher in
                guard let apiService = apiService else {
                    return Empty().eraseToAnyPublisher()
                }
                return apiService.imageDataPublisher(fromURLString: imageURLString)
            }
            .replaceError(with: Data())
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$characterImageData)
        
        characterSharedPublisher
            .map(\.created)
            .removeDuplicates()
            .assign(to: &$created)
        
        characterSharedPublisher
            .map(\.url)
            .removeDuplicates()
            .assign(to: &$url)
        
        characterSubject.send(character)
    }
}
