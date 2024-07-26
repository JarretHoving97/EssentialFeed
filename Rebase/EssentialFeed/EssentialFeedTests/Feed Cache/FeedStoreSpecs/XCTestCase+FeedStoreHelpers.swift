//
//  Copyright © Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

func uniqueImageFeed() -> [LocalFeedImage] {
	[uniqueImage(), uniqueImage()]
}

func uniqueImage() -> LocalFeedImage {
	LocalFeedImage(id: UUID(), description: "any description", location: "any location", url: anyURL())
}

func anyURL() -> URL {
	URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
	NSError(domain: "any error", code: 0)
}

extension XCTestCase {
	@discardableResult
	func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
		let exp = expectation(description: "Wait for cache insertion")
		var insertionError: Error?
		sut.insert(cache.feed, timestamp: cache.timestamp) { result in
            if case let .failure(error) = result {
                insertionError = error
            }
		
			exp.fulfill()
		}
		wait(for: [exp], timeout: 1.0)
		return insertionError
	}

	@discardableResult
	func deleteCache(from sut: FeedStore) -> Error? {
		let exp = expectation(description: "Wait for cache deletion")
		var deletionError: Error?
        
        sut.deletedCachedFeed { result in
            if case let .failure(error) = result {
                deletionError = error
               
            }
            exp.fulfill()
        }
		wait(for: [exp], timeout: 1.0)
		return deletionError
	}

    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: FeedStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
		expect(sut, toRetrieve: expectedResult, file: file, line: line)
		expect(sut, toRetrieve: expectedResult, file: file, line: line)
	}

    func expect(_ sut: FeedStore, toRetrieve expectedResult: FeedStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
		let exp = expectation(description: "Wait for cache retrieval")
        

		sut.retrieve { retrievedResult in
			switch (expectedResult, retrievedResult) {
                
            case (.success(.none), .success(.none)),
                (.failure, .failure):
                
                break

            case let (.success(.some(expectedFeed)), .success(.some(retrievedFeed))):
                
                XCTAssertEqual(retrievedFeed.feed, expectedFeed.feed, file: file, line: line)
                
                XCTAssertEqual(retrievedFeed.timestamp, retrievedFeed.timestamp, file: file, line: line)
                

			default:
				XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
			}

			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
	}
}
