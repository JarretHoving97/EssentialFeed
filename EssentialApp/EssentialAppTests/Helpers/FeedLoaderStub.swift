//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 07/10/2024.
//

import Foundation
import EssentialFeed
import XCTest

public class FeedLoaderStub: FeedLoader {
    
    let result: FeedLoader.Result
    
    public init(result: FeedLoader.Result) {
        self.result = result
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

public func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any_url.com")!)]
}

public func anyData() -> Data {
    return "Any-data".data(using: .utf8)!
}
