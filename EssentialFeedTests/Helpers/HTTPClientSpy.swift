//
//  HTTPClientSpy.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 30/09/2024.
//

import Foundation
import EssentialFeed

public final class HTTPClientSpy: HTTPClient {
    
    private struct Task: HTTPClientTask {
        func cancel() {}
    }

    private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
    
    var requestedURLs: [URL] {
        return messages.map({$0.url})
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task()
    }
    
    func complete(with error: Error, at index: Int = 0 ) {
        messages[index].completion(.failure(error))
    }
    
    func complete(with statusCode: Int, data: Data, at index: Int = 0 ) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        
        // trigger the completion inside of messages
        messages[index].completion(.success((data, response)))
    }
}
