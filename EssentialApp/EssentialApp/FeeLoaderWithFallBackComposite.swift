//
//  FeeLoaderWithFallBackComposite.swift
//  EssentialApp
//
//  Created by Jarret Hoving on 06/10/2024.
//

import EssentialFeed
import Foundation

public class FeedLoaderWithFallBackComposite: FeedLoader {
    let primary: FeedLoader
    let fallback: FeedLoader

    public init(primaryLoader: FeedLoader, fallBackLoader: FeedLoader) {
        self.primary = primaryLoader
        self.fallback = fallBackLoader
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
