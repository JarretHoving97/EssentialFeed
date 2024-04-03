//
//  CodableFeedStoreTestss.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 03/04/2024.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}


final class CodableFeedStoreTestss: XCTestCase {

    func test_retrieve_deliversEmptyOnCache() {
        let sut = CodableFeedStore()
        
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { result in
            switch result {
            case .empty:
                break;
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

}
