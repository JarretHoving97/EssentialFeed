//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 07/10/2024.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {

    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed))
        
        expect(sut, toCompleteWith: .success(feed))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_load_cachesLoadedFeedOnLOaderSuccess() {
        let feed = uniqueFeed()
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .success(feed), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.messages, [.save(feed)])
    }
    
    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache feed on load error")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(loaderResult: FeedLoader.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> FeedLoader {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private class CacheSpy: FeedCache  {

        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save([FeedImage])
        }
        
        func save(_ feed: [EssentialFeed.FeedImage], completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(feed))
            completion(.success(()))
        }
        
    }
}
