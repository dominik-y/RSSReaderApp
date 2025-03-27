import Foundation
import SwiftUI

struct Feed: Identifiable, Equatable {
    let id = UUID()
    let url: URL
    let title: String
    let description: String
    let imageUrl: URL?
    var isFavorite: Bool = false
    var items: [FeedItem] = []
}

struct FeedStore: Codable {
    var feeds: [StoredFeed] = []
}

struct StoredFeed: Codable, Identifiable {
    var id = UUID()
    let urlString: String
    let title: String
    let description: String
    let imageUrlString: String?
    var isFavorite: Bool
    
    var url: URL? {
        URL(string: urlString)
    }
    
    var imageUrl: URL? {
        guard let imageUrlString = imageUrlString else { return nil }
        return URL(string: imageUrlString)
    }
    
    init(from feed: Feed) {
        self.urlString = feed.url.absoluteString
        self.title = feed.title
        self.description = feed.description
        self.imageUrlString = feed.imageUrl?.absoluteString
        self.isFavorite = feed.isFavorite
    }
    
    func toFeed() -> Feed {
        Feed(
            url: URL(string: urlString)!,
            title: title,
            description: description,
            imageUrl: imageUrl,
            isFavorite: isFavorite
        )
    }
}
