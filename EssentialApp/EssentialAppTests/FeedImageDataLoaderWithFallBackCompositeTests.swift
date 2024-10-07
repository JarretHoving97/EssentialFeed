//
//  FeedImageDataLoaderWithFallBackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 06/10/2024.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedImageDataLoaderWithFallBackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryImageDataOnPrimaryLoaderSuccess() {

        let expectedData = anyData()
        let sut = makeSUT(primaryResult: .success(expectedData), fallbackResult: .success(anyData()))
        
        expect(sut, toCompleteWith: .success(expectedData))
    }
    
    func test_load_deliversFallbackImageDataOnPrimaryFailure() {
        let expectedData = "Any-data".data(using: .utf8)!

    
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(expectedData))
        
        expect(sut, toCompleteWith: .success(expectedData))
    }
    
    func test_load_deliversErrorOnBothPrimaryAndFallBackFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    // MARK: Helpers
    
    private func expect(_ sut: FeedImageDataLoaderWithFallBackComposite, toCompleteWith expectedResult: FeedImageDataLoader.Result) {
        
        let exp = expectation(description: "Wait for load completion")
        
        let _ = sut.loadImageData(from: URL(string: "http://any-url.com")!) { retrievedResult in
            
            switch (retrievedResult, expectedResult) {
            
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(retrievedResult) instead")
            }

            exp.fulfill()
        }
        
      wait(for: [exp])
    }
    
    private func makeSUT(primaryResult: FeedImageDataLoader.Result, fallbackResult: FeedImageDataLoader.Result, file: StaticString = #file, line: UInt = #line) -> FeedImageDataLoaderWithFallBackComposite {
        
        let primaryLoader = LoaderStub(result: primaryResult)
        let fallbackLoader = LoaderStub(result: fallbackResult)
        let sut = FeedImageDataLoaderWithFallBackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(primaryLoader)
        trackForMemoryLeaks(fallbackLoader)
        trackForMemoryLeaks(sut)
        
        return sut
        
    }
    
    class TaskWrapper: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
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
}
