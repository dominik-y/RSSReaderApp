//
//  RSSReaderAppApp.swift
//  RSSReaderApp
//
//  Created by Dominik Maric on 27.03.2025..
//

import SwiftUI

@main
struct FeedReaderApp: App {
    let dependencies = FeedDependecies()
    
    var body: some Scene {
        WindowGroup {
            FeedDashboardView(
                feedListViewModel: FeedListViewModel(
                    repository: dependencies.feedRepository
                )
            )
        }
    }
}
