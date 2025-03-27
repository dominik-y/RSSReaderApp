import Foundation
import SwiftUI

struct AddFeedView: View {
    @ObservedObject var viewModel: FeedListViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Feed URL", text: $viewModel.newFeedUrl,
                        prompt: Text("https://example.com/rss")
                    )
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                }

                Section {
                    Button("Add Feed") {
                        viewModel.addFeed()
                    }
                    .disabled(
                        viewModel.newFeedUrl.isEmpty || viewModel.isLoading
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.accentColor)
                }

                Section {
                    HStack {
                        Text("Need inspiration?")
                        Spacer()
                        Link(
                            "Find popular RSS feeds",
                            destination: URL(
                                string:
                                    "https://blog.feedspot.com/world_news_rss_feeds/"
                            )!)
                    }
                }
            }
            .disabled(viewModel.isLoading)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Add RSS Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
