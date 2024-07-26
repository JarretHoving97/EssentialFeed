//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 25/03/2024.
//

import Foundation

 final class FeedCachePolicy {
    
    private init() {}
    
    static private let calendar = Calendar(identifier: .gregorian)
    
    static private var maxCacheDateInDays: Int {
        return 7
    }
    
     static func validate(_ timestamp: Date, against date: Date) -> Bool {
        
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheDateInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
    
}
