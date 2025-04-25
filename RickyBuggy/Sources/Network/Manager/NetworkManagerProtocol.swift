//
//  NetworkManagerProtocol.swift
//  RickyBuggy
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func publisher(path: String,
                   method: HTTPMethod,
                   headers: [String: String]?,
                   body: Data?,
                   timeout: TimeInterval) -> AnyPublisher<Data, Error>
    func publisher(fromURLString urlString: String) -> Publishers.MapError<Publishers.MapKeyPath<Publishers.FlatMap<URLSession.DataTaskPublisher, Publishers.ReceiveOn<Publishers.SetFailureType<Optional<URL>.Publisher, URLError>, DispatchQueue>>, Data>, Error>
}
