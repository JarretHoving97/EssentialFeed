//
//  EssentialFeedAPIEndToEndTests.swift
//  EssentialFeedAPIEndToEndTests
//
//  Created by Jarret Hoving on 13/02/2024.
//

import XCTest
import EssentialFeed

final class EssentialFeedAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
  
        switch getFeedResult() {
        case .success(let items)?:
            XCTAssertEqual(items.count, 8, "Expected 8 items in test account feed")

        case .failure(let error)?:
            XCTFail("Expected success result, got \(error) instead")
        default:
            XCTFail("Expected success result, got null instead")
        }
    }
    
    // MARK: Helpers
    
    private func getFeedResult(file: StaticString = #filePath, line: UInt = #line) -> LoadFeedResult? {
        let testServerURL = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed")!
        let client = URLSessionHTTPClient() 
        let loader = RemoteFeedLoader(url: testServerURL, client: client)
        
        checkForMemoryLeaks(client, file: file, line: line)
        checkForMemoryLeaks(loader, file: file, line: line)
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: LoadFeedResult?
        
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }

}
