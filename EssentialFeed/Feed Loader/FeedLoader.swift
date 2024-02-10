//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 04/02/2024.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
