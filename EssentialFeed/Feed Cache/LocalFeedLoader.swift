//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 06/03/2024.
//

import Foundation

class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
  
        store.deletedCachedFeed { [weak self] error in
            guard let self else { return }
            if let cachedDeletionError = error {
                completion(cachedDeletionError)
            } else {
                cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping (Error?) -> Void) {
        self.store.insert(items, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deletedCachedFeed(completion: @escaping DeletionCompletion)
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
