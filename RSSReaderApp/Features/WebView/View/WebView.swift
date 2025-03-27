//
//  WebView.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import Foundation
import SwiftUI

struct WebView: View {
    let url: URL
    @State private var isLoading = true

    var body: some View {
        VStack {
            VStack {
                if isLoading {
                    ProgressView("Loading article...")
                        .padding()
                }

                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onAppear {
                                    isLoading = false
                                }
                        } else if phase.error != nil {
                            Color.clear
                                .frame(height: 0)
                                .onAppear {
                                    isLoading = false
                                }
                        } else if isLoading {
                            Color.clear.frame(height: 0)
                        }
                    }

                    Text("View article at:")
                        .font(.headline)

                    Text(url.absoluteString)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    Link(destination: url) {
                        Text("Tap to view full article")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Text("The article will open in your default browser")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
            }

            Spacer()
        }
    }
}
