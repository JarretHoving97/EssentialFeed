//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 09/10/2024.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    
    private let loader: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(loader: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.loader = loader
        self.cache = cache
    }
    
    class TaskWrapper: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any EssentialFeed.FeedImageDataLoaderTask {
        
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
