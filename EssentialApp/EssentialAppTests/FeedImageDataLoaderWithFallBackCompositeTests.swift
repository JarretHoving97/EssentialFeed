//
//  FeedImageDataLoaderWithFallBackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 06/10/2024.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithCompoisite: FeedImageDataLoader {
    
    let primaryLoader: FeedImageDataLoader
    let fallbackLoader: FeedImageDataLoader
    
    init(primaryLoader: FeedImageDataLoader, fallbackLoader: FeedImageDataLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    public class TaskWrapper: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    
    @discardableResult
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any FeedImageDataLoaderTask {
        return primaryLoader.loadImageData(from: url, completion: completion)
    }
    
}

final class FeedImageDataLoaderWithFallBackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryImageDataOnPrimaryLoaderSuccess() {
        let expectedData = "Any-data".data(using: .utf8)!
        
        let primaryLoader = LoaderStub(result: .success(expectedData))
        let fallbackLoader = LoaderStub(result: .success(Data()))
 
    
        let sut = FeedImageDataLoaderWithCompoisite(primaryLoader: primaryLoader, fallbackLoader: fallbackLoader)
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.loadImageData(from: URL(string: "http//any-url.com")!) { result in
            
            switch result {
                
            case let .success(data):
                XCTAssertEqual(data, expectedData)
                
            default:
                XCTFail("Expected SUT to succeed")
            }
            
            exp.fulfill()
        }
        
      wait(for: [exp])
        
    }
    
    // MARK: Helpers
    
    
    private class LoaderStub: FeedImageDataLoader {
        let result: FeedImageDataLoader.Result
        
        
        init(result: FeedImageDataLoader.Result) {
            self.result = result
        }
        
        @discardableResult
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any EssentialFeed.FeedImageDataLoaderTask {
            completion(result)
            
            return TaskWrapper()
        }
    }
    
    public class TaskWrapper: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    
    
}
