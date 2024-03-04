//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 04/03/2024.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deletedCachedFeed()
        
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
    
    func deletedCachedFeed() {
        deleteCachedFeedCallCount += 1
    }

}

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_deosNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    
    // MARK: - Helpers
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL() )
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://a-url.com")!
    }
    
}


