//
//  MainTheadDispatchDecorator.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 13/09/2024.
//

import Foundation
import EssentialFeed

final class MainTheadDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { completion() }
        }
         
        completion()
    }
}

extension MainTheadDispatchDecorator: FeedLoader where T == FeedLoader {
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        dispatch { [weak self] in
            self?.decoratee.load(completion: completion)
        }
    }
}

extension MainTheadDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
