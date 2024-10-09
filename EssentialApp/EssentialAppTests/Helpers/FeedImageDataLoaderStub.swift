//
//  FeedImageDataLoaderStub.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 08/10/2024.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderStub: FeedImageDataLoader {
    let result: FeedImageDataLoader.Result
    
    class TaskWrapper: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    public init(result: FeedImageDataLoader.Result) {
        self.result = result
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any EssentialFeed.FeedImageDataLoaderTask {
        completion(result)
    
        return TaskWrapper()
    }
}
