//
//  RSSParser.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import Combine
import SwiftUI

protocol RSSParserProtocol {
    func parse(data: Data, url: URL) -> AnyPublisher<Feed, Error>
}

class RSSParser: RSSParserProtocol {
    func parse(data: Data, url: URL) -> AnyPublisher<Feed, Error> {
        return Future<Feed, Error> { promise in
            let parser = XMLParser(data: data)
            let delegate = RSSParserDelegate(url: url)
            parser.delegate = delegate
            
            let success = parser.parse()
            
            if success, let feed = delegate.currentFeed {
                promise(.success(feed))
            } else {
                promise(.failure(FeedError.parsingError))
            }
        }.eraseToAnyPublisher()
    }
}
