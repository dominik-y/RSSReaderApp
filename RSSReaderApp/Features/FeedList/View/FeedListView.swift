import Foundation
import SwiftUI

struct FeedListView: View {
    @ObservedObject var feedListViewModel: FeedListViewModel

    var body: some View {
        Group {
            if feedListViewModel.isLoading && feedListViewModel.feeds?.isEmpty == true
            {
                ProgressView("Loading feeds...")
            } else if feedListViewModel.filteredFeeds.isEmpty {
                if feedListViewModel.showFavoritesOnly {
                    ContentUnavailableView(
                        "No Favorite Feeds", systemImage: "star",
                        description: Text(
                            "Add feeds to your favorites to see them here."))
                } else {
                    ContentUnavailableView(
                        "No Feeds", systemImage: "tray.fill",
                        description: Text("Tap + to add a feed."))
                }
            } else {
                List {
                    ForEach(feedListViewModel.filteredFeeds) { feed in
                        NavigationLink(
                            destination: FeedDetailView(
                                viewModel: FeedDetailViewModel(feed: feed))
                        ) {
                            FeedRowView(
                                feed: feed,
                                favoriteTapped: {
                                    feedListViewModel.toggleFavorite(for: feed)
                                }
                            )
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            feedListViewModel.removeFeed(
                                feedListViewModel.filteredFeeds[index])
                        }
                    }
                    .overlay(
                        feedListViewModel.isLoading
                            ? AnyView(ProgressView()) : AnyView(EmptyView())
                    )
                }

            }
        }
    }
}
