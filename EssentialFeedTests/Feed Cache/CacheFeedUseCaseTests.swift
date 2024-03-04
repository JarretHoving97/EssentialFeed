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
        let (_, store)  = makeSUT()
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store)  = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        checkForMemoryLeaks(store, file: file, line: line)
        checkForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL() )
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://a-url.com")!
    }
    
}


