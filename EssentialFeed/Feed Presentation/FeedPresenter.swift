//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Jarret Hoving on 27/09/2024.
//

import Foundation

// MARK: ErrorView
public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

// MARK: LoadingVIew

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}


// MARK: FeedView

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public struct FeedViewModel {
    public let feed: [FeedImage]
}


public final class FeedPresenter {
    
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    private let feedView: FeedView
    
    
    public static var title: String {
        return  NSLocalizedString(
             "FEED_VIEW_TITLE",
             tableName: "Feed",
             bundle: Bundle(for: FeedPresenter.self),
             comment: "Title for the feed view")
    }
    
    private var feedLoadError: String {
       return  NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public init(loadingView: FeedLoadingView, errorView: FeedErrorView, feedView: FeedView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.feedView = feedView
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(message: feedLoadError))
    }
}
