import Foundation
import SwiftUI
import Combine

class FeedDetailViewModel: ObservableObject {
    @Published var feed: Feed
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let repository: FeedRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        feed: Feed,
        repository: FeedRepositoryProtocol = FeedRepository()
    ) {
        self.feed = feed
        self.repository = repository
        loadFeedItems()
    }
    
    func loadFeedItems() {
        isLoading = true
        
        repository.fetchFeedItems(for: feed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            } receiveValue: { [weak self] updatedFeed in
                self?.feed = updatedFeed
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        feed = repository.toggleFavorite(for: feed)
    }
}
