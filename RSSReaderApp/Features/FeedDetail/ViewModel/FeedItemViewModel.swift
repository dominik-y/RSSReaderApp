import Foundation

class FeedItemViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var pubDate: Date?
    @Published var imageUrl: URL?
    
    init(item: FeedItem) {
        self.title = item.title
        self.description = item.description
        self.pubDate = item.pubDate
        self.imageUrl = item.imageUrl
    }
}
