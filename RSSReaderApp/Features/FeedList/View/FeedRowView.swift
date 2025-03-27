import Foundation
import SwiftUI

struct FeedRowView: View {
    let feed: Feed
    let favoriteTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = feed.imageUrl {
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
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "doc.text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(feed.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(feed.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}
