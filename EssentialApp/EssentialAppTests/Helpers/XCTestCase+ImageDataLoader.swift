//
//  XCTestCase+ImageDataLoader.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 08/10/2024.
//

import Foundation
import EssentialFeed
import EssentialApp
import XCTest


protocol FeedImageDataLoaderTestCase: XCTestCase {}

extension FeedImageDataLoaderTestCase {
   
    func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result) {
        
        let exp = expectation(description: "Wait for load completion")
        
        let _ = sut.loadImageData(from: URL(string: "http://any-url.com")!) { retrievedResult in
            
            switch (retrievedResult, expectedResult) {
            
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(retrievedResult) instead")
            }

            exp.fulfill()
        }
        
      wait(for: [exp])
    }
}


