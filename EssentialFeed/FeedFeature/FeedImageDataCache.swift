//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 09/10/2024.
//

import Foundation

public protocol FeedImageDataCache {
    
    typealias SaveResult = Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
