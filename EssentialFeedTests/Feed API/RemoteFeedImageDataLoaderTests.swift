//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 29/09/2024.
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
    
    init(client: Any) {
        
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequests() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.is)
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        checkForMemoryLeaks(sut, file: file, line: line)
        checkForMemoryLeaks(client, file: file, line: line)

        return (sut, client)
    }

    private class HTTPClientSpy {
        var requestedURLs = [URL]()
    }

}
