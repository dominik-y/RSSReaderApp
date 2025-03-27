//
//  NetworkService.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func fetch(from url: URL) -> AnyPublisher<Data, Error>
}

class NetworkService: NetworkServiceProtocol {
    func fetch(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
