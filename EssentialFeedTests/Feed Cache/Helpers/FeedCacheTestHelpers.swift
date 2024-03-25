//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 19/03/2024.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL() )
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let feed = [uniqueImage(), uniqueImage()]
    let local = feed.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    
    return (feed, local)
}

extension Date {
    
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCaceMaxAgeInDays)
    }
    
    private var feedCaceMaxAgeInDays: Int {
        return 7
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
