//
//  FeedService.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import Foundation
import Combine
import SwiftUI

protocol StorageServiceProtocol {
    func saveFeeds(_ feedStore: FeedStore)
    func loadFeeds() -> FeedStore?
}

class StorageService: StorageServiceProtocol {
    private let feedsKey = "saved_feeds"
    
    func saveFeeds(_ feedStore: FeedStore) {
        if let encoded = try? JSONEncoder().encode(feedStore) {
            UserDefaults.standard.set(encoded, forKey: feedsKey)
        }
    }
    
    func loadFeeds() -> FeedStore? {
        guard let data = UserDefaults.standard.data(forKey: feedsKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(FeedStore.self, from: data)
    }
}
