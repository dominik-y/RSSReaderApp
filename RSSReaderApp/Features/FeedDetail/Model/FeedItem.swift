import Foundation
import SwiftUI

struct FeedItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let pubDate: Date?
    let link: URL?
    let imageUrl: URL?
}

