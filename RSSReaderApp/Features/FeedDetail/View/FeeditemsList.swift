import Foundation
import SwiftUI

struct FeedItemsList: View {
    let items: [FeedItem]
    let feedUrl: URL

    var body: some View {
        ForEach(items) { item in
            NavigationLink(
                destination: WebViewContainer(url: item.link ?? feedUrl)
            ) {
                let feedItemViewModel = FeedItemViewModel(item: item)
                FeedItemRowView(
                    feedItemViewModel: feedItemViewModel)
            }
        }
    }
}
