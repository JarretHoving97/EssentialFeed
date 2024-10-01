//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 19/03/2024.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "https://a-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}
