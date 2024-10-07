//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 07/10/2024.
//

import Foundation
import EssentialFeed
import XCTest

class FeedLoaderStub: FeedLoader {
    
    let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
     func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any_url.com")!)]
}

func anyData() -> Data {
    return "Any-data".data(using: .utf8)!
}
