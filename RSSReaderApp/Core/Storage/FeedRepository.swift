//
//  FeedRepository.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import Combine
import Foundation

protocol FeedRepositoryProtocol {
    func fetchFeeds() -> AnyPublisher<[Feed], Error>
    func fetchFeedItems(for feed: Feed) -> AnyPublisher<Feed, Error>
    func addFeed(url: URL) -> AnyPublisher<Feed, Error>
    func removeFeed(_ feed: Feed)
    func toggleFavorite(for feed: Feed) -> Feed
    func saveFeeds()
}

enum FeedError: Error {
    case invalidUrl
    case networkError
    case parsingError
    case feedAlreadyExists
}

class FeedRepository: FeedRepositoryProtocol {
    private let rssParser: RSSParserProtocol
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol

    @Published var feeds: [Feed] = []

    init(
        rssParser: RSSParserProtocol = RSSParser(),
        networkService: NetworkServiceProtocol = NetworkService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.rssParser = rssParser
        self.networkService = networkService
        self.storageService = storageService

        if let storedFeeds = storageService.loadFeeds() {
            self.feeds = storedFeeds.feeds.map { $0.toFeed() }
        }
    }

    func fetchFeeds() -> AnyPublisher<[Feed], Error> {
        return Just(feeds)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchFeedItems(for feed: Feed) -> AnyPublisher<Feed, Error> {
        guard let index = feeds.firstIndex(where: { $0.url == feed.url }) else {
            return Fail(error: FeedError.invalidUrl).eraseToAnyPublisher()
        }

        return networkService.fetch(from: feed.url)
            .flatMap { [weak self] data -> AnyPublisher<Feed, Error> in
                guard let self = self else {
                    return Fail(error: FeedError.networkError)
                        .eraseToAnyPublisher()
                }

                return self.rssParser.parse(data: data, url: feed.url)
                    .map { parsedFeed in
                        var updatedFeed = self.feeds[index]
                        updatedFeed.items = parsedFeed.items
                        self.feeds[index] = updatedFeed
                        return updatedFeed
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func addFeed(url: URL) -> AnyPublisher<Feed, Error> {
        if feeds.contains(where: { $0.url == url }) {
            return Fail(error: FeedError.feedAlreadyExists)
                .eraseToAnyPublisher()
        }

        return networkService.fetch(from: url)
            .flatMap { [weak self] data -> AnyPublisher<Feed, Error> in
                guard let self = self else {
                    return Fail(error: FeedError.networkError)
                        .eraseToAnyPublisher()
                }

                return self.rssParser.parse(data: data, url: url)
                    .map { feed in
                        self.feeds.append(feed)
                        self.saveFeeds()
                        return feed
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func removeFeed(_ feed: Feed) {
        feeds.removeAll(where: { $0.url == feed.url })
        saveFeeds()
    }

    func toggleFavorite(for feed: Feed) -> Feed {
        guard let index = feeds.firstIndex(where: { $0.url == feed.url }) else {
            return feed
        }

        var updatedFeed = feeds[index]
        updatedFeed.isFavorite.toggle()
        feeds[index] = updatedFeed
        saveFeeds()

        return updatedFeed
    }

    func saveFeeds() {
        let storedFeeds = FeedStore(feeds: feeds.map { StoredFeed(from: $0) })
        storageService.saveFeeds(storedFeeds)
    }
}
