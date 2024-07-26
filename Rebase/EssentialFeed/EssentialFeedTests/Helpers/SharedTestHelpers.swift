//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 19/03/2024.
//

import Foundation
import XCTest
import EssentialFeed

var emptyCache: CachedFeed { CachedFeed(feed: [], timestamp: Date.now) }

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
