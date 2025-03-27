import Foundation
import SwiftUI

struct FeedDetailView: View {
    @StateObject var viewModel: FeedDetailViewModel

    var body: some View {
        List {
            Section {
                FeedHeaderView(feed: viewModel.feed)
            }

            if viewModel.feed.items.isEmpty && !viewModel.isLoading {
                ContentUnavailableView(
                    "No Items", systemImage: "tray",
                    description: Text("No items found in this feed."))
            } else {
                FeedItemsList(
                    items: viewModel.feed.items, feedUrl: viewModel.feed.url)
            }
        }
        .navigationTitle(viewModel.feed.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Label(
                        "Favorite",
                        systemImage: viewModel.feed.isFavorite
                            ? "star.fill" : "star"
                    )
                    .foregroundColor(viewModel.feed.isFavorite ? .yellow : nil)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.loadFeedItems()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
        }
        .refreshable {
            viewModel.loadFeedItems()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert(
            "Error", isPresented: $viewModel.showError,
            presenting: viewModel.errorMessage
        ) { _ in
            Button("OK") {}
        } message: { errorMessage in
            Text(errorMessage)
        }
    }
}
