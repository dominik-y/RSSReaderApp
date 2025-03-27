//
//  FeedDependencies.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

class FeedDependecies {
    lazy var feedRepository: FeedRepositoryProtocol = {
        let repo = FeedRepository()
        return repo
    }()
}
