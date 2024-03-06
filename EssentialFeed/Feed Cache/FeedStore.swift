//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 06/03/2024.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deletedCachedFeed(completion: @escaping DeletionCompletion)
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
