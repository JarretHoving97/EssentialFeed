//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 04/02/2024.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>
 
protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
