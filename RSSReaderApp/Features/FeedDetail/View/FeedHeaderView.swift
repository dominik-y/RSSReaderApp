import Foundation
import SwiftUI

struct FeedHeaderView: View {
    let feed: Feed

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                if let imageUrl = feed.imageUrl {
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .imageScale(.large)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "doc.text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(feed.title)
                        .font(.headline)

                    Text(feed.url.absoluteString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !feed.description.isEmpty {
                Text(feed.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

