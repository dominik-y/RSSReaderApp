//
//  WebViewContainer.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import Foundation
import SwiftUI

struct WebViewContainer: View {
    let url: URL
    @Environment(\.openURL) private var openURL
    @State private var useExternalBrowser = false

    var body: some View {
        VStack {
            if useExternalBrowser {
                ContentUnavailableView(
                    "External Browser", systemImage: "safari",
                    description: Text("Opening in external browser...")
                )
                .onAppear {
                    openURL(url)
                }
            } else {
                WebView(url: url)
            }
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if !useExternalBrowser {
                        useExternalBrowser = true
                    } else {
                        openURL(url)
                    }
                } label: {
                    Label("Open in Browser", systemImage: "safari")
                }
            }
        }
    }
}
