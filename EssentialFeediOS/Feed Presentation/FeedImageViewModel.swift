//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 23/08/2024.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
