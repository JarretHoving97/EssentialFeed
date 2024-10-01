//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 01/10/2024.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
