//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 06/03/2024.
//

import Foundation

public final class FeedCachePolicy {
    
    private init() {}
    
    static private let calendar = Calendar(identifier: .gregorian)
    
    static private var maxCacheDateInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheDateInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
    
}

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func validateCache() {
        store.retrieve {  [weak self] result in
            
            guard let self else { return }
            switch result {
            case .failure:
                self.store.deletedCachedFeed {_ in }
                
            case let .found(_, timestamp: timestamp) where !FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deletedCachedFeed {_ in }
                
                
            case .empty, .found: break
            }
        }
    }
}

extension LocalFeedLoader {
    
    public typealias SaveResult = Error?
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        
        store.deletedCachedFeed { [weak self] error in
            guard let self else { return }
            if let cachedDeletionError = error {
                completion(cachedDeletionError)
            } else {
                cache(feed, with: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        self.store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

extension LocalFeedLoader: FeedLoader {
    
    public typealias LoadResult = LoadFeedResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .found(feed, timestamp) where FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(feed.toModels()))
                
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
    
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}
