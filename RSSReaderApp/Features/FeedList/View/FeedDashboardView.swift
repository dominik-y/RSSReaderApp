import Combine
import SwiftUI

struct FeedDashboardView: View {
    @ObservedObject private var feedListViewModel: FeedListViewModel

    init(feedListViewModel: FeedListViewModel) {
        _feedListViewModel = .init(wrappedValue: feedListViewModel)
    }

    var body: some View {
        NavigationStack {
            FeedListView(feedListViewModel: feedListViewModel)
                .navigationTitle("RSS Feeds")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            feedListViewModel.showFavoritesOnly.toggle()
                        } label: {
                            Label(
                                feedListViewModel.showFavoritesOnly
                                    ? "Show All" : "Favorites",
                                systemImage: feedListViewModel.showFavoritesOnly
                                    ? "list.bullet" : "star.fill"
                            )
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            feedListViewModel.showAddFeedSheet = true
                        } label: {
                            Label("Add Feed", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $feedListViewModel.showAddFeedSheet) {
                    AddFeedView(viewModel: feedListViewModel)
                }
                .refreshable {
                    feedListViewModel.loadFeeds()
                }
                .alert(
                    "Error", isPresented: $feedListViewModel.showError,
                    presenting: feedListViewModel.errorMessage
                ) { (errorMessage: String?) in
                    Button("OK") {}
                } message: { errorMessage in
                    Text(errorMessage)
                }
        }
    }
}
