import Foundation
import SwiftUI

struct FeedItemRowView: View {
    @ObservedObject var feedItemViewModel: FeedItemViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                if let imageUrl = feedItemViewModel.imageUrl {
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .imageScale(.large)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(feedItemViewModel.title)
                        .font(.headline)
                        .lineLimit(2)

                    if let pubDate = feedItemViewModel.pubDate {
                        Text(pubDate, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Text(feedItemViewModel.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }
}
