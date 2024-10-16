//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 09/08/2024.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import Combine


public final class FeedUIComposer {
    
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        
        let presentationAdapter = FeedLoaderPresentationAdapter(
            feedLoader: { feedLoader().dispatchOnMainQueue() })
        
        let feedController = makeFeedViewController(
            delegate: presentationAdapter,
            title: FeedPresenter.title
        )
        
        presentationAdapter.presenter = FeedPresenter(
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { imageLoader($0).dispatchOnMainQueue() }
            )
        )
        
        return feedController
    }
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}

