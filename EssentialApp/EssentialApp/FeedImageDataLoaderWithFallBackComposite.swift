//
//  FeedImageDataLoaderWithFallBackComposite.swift
//  EssentialApp
//
//  Created by Jarret Hoving on 06/10/2024.
//

import Foundation
import EssentialFeed

public class FeedImageDataLoaderWithFallBackComposite: FeedImageDataLoader {
    
    let primary: FeedImageDataLoader
    let fallback: FeedImageDataLoader
    
    public init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    private class TaskWrapper: FeedImageDataLoaderTask {
        
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any EssentialFeed.FeedImageDataLoaderTask {
        
        let task = TaskWrapper()
        
        task.wrapped = primary.loadImageData(from: url) { [weak self] result in
            
            switch result {
            case .success:
                completion(result)
                
            case .failure:
                task.wrapped =  self?.fallback.loadImageData(from: url, completion: completion)
            }
        }
        return task
    }
}

