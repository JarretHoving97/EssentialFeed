//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 07/10/2024.
//

import Foundation

public protocol FeedCache {
    
    typealias SaveResult = Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
    
}
