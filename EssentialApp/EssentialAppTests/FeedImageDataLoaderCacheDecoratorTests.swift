//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 08/10/2024.
//

import XCTest
import EssentialFeed

class ImageDataLoaderCacheDecorator: FeedImageDataLoader {
    
    let result: FeedImageDataLoader.Result
    
    init(result: FeedImageDataLoader.Result) {
        self.result = result
    }
    
    class TaskWrapper: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    @discardableResult
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any EssentialFeed.FeedImageDataLoaderTask {
        completion(result)
        
        return TaskWrapper()
    }
}


final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    
    func test_load_deliversDataOnLoaderSuccess() {
    
        let sut = ImageDataLoaderCacheDecorator(result: .success(anyData()))
        
        let exp = expectation(description: "Waiting loading to be finished")
        
        sut.loadImageData(from: URL(string: "http://any-yrl.com")!) { result in
            
            switch result {
            case let .success(data):
                XCTAssertEqual(data, anyData())
                
            default:
                XCTFail("Expected to deliver success")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
