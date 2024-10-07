//
//  XCTestCase+FeedLoader.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 07/10/2024.
//

import XCTest
import EssentialFeed

protocol FeedLoaderTestCase: XCTestCase {}

extension FeedLoaderTestCase {
    
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for loading completion")
        
        sut.load { retrievedResult in
            switch (retrievedResult, expectedResult) {
            case let (.success(retrievedFeed), .success(expectedFeed)):
                XCTAssertEqual(retrievedFeed, expectedFeed, "")
                
            case (.failure, .failure):
                break;
                
            default:
                XCTFail("Expected \(expectedResult), got \(retrievedResult) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
