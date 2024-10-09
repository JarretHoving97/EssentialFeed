//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 08/10/2024.
//

import XCTest
import EssentialFeed

protocol FeedImageDataCache {
    
    typealias SaveResult = Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}

class ImageDataLoaderCacheDecorator: FeedImageDataLoader {
    
    let loader: FeedImageDataLoader
    let cache: FeedImageDataCache
    
    init(loader: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.loader = loader
        self.cache = cache
    }
    
    class TaskWrapper: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any EssentialFeed.FeedImageDataLoaderTask {
        
        loader.loadImageData(from: url) { [weak self] result in
            completion(result.map { imageData in
                self?.cache.saveIgnoringResult(imageData, url: url)
                return imageData
                }
            )
        }
    }
}

private extension FeedImageDataCache {
    func saveIgnoringResult(_ imageData: Data, url: URL) {
        save(imageData, for: url) { _ in }
    }
}



final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    
    func test_load_deliversDataOnLoaderSuccess() {

        let sut = makeSUT(loaderResult: .success(anyData()))
        expect(sut, toCompleteWith: .success(anyData()))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    func test_load_cachesImageDataOnLoaderSuccess() {
        let cache = CacheSpy()
        
        let sut = makeSUT(loaderResult: .success(anyData()), cache: cache)
    
        let _ = sut.loadImageData(from: anyURL()) { _ in }
        
        XCTAssertEqual(cache.messages, [.save(anyData())])
    }
    
    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
    
        let _ = sut.loadImageData(from: anyURL()) { _ in }
    
        
        XCTAssertEqual(cache.messages, [])
    }
    

    // MARK: Helpers
    func makeSUT(loaderResult: FeedImageDataLoader.Result, cache: CacheSpy = .init()) -> FeedImageDataLoader {
        
        let loader = FeedImageDataLoaderStub(result: loaderResult)
        let sut = ImageDataLoaderCacheDecorator(loader: loader, cache: cache)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        
        return sut
        
    }
    
    class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        init() {}
        
        enum Message: Equatable {
           case save(Data)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(data))
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://url.com")!
    }
}
