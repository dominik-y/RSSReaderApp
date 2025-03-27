import Foundation
import Combine
import SwiftUI

class FeedListViewModel: ObservableObject {
    @Published var feeds: [Feed]? = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var newFeedUrl = ""
    @Published var showAddFeedSheet = false
    @Published var showFavoritesOnly = false

    private let repository: FeedRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: FeedRepositoryProtocol = FeedRepository()) {
        self.repository = repository
        
        loadFeeds()
    }
    
    func loadFeeds() {
        isLoading = true
        
        repository.fetchFeeds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            } receiveValue: { [weak self] feeds in
                self?.feeds = feeds
            }
            .store(in: &cancellables)
    }
    
    func addFeed() {
        guard let url = URL(string: newFeedUrl) else {
            errorMessage = "Invalid URL"
            showError = true
            return
        }
        
        isLoading = true
        
        repository.addFeed(url: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    switch error {
                    case FeedError.feedAlreadyExists:
                        self?.errorMessage = "This feed already exists"
                    case FeedError.invalidUrl:
                        self?.errorMessage = "Invalid URL"
                    case FeedError.networkError:
                        self?.errorMessage = "Network error"
                    case FeedError.parsingError:
                        self?.errorMessage = "Not a valid RSS feed"
                    default:
                        self?.errorMessage = error.localizedDescription
                    }
                    self?.showError = true
                }
            } receiveValue: { [weak self] _ in
                self?.newFeedUrl = ""
                self?.showAddFeedSheet = false
                self?.loadFeeds()
            }
            .store(in: &cancellables)
    }
    
    func removeFeed(_ feed: Feed) {
        repository.removeFeed(feed)
        loadFeeds()
    }
    
    func toggleFavorite(for feed: Feed) {
        let updatedFeed = repository.toggleFavorite(for: feed)
        
        if let index = feeds?.firstIndex(where: { $0.url == feed.url }) {
            feeds?[index] = updatedFeed
        }
    }
    
    var filteredFeeds: [Feed] {
        if showFavoritesOnly {
            return feeds!.filter { $0.isFavorite }
        } else {
            return feeds!
        }
    }
}

