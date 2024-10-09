//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Jarret Hoving on 07/10/2024.
//

import EssentialFeed

public final class FeedLoaderCacheDecorator: FeedLoader {
    
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            
            completion(result.map { feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }
}


private extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed, completion: {_ in })
    }
}
