//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 23/08/2024.
//

import Foundation
import EssentialFeed

protocol FeedImageView {
    associatedtype Image
    
    func display(_ model: FeedImageViewModel<Image>)
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    internal init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    private struct InvalidImageDataError: Error {}
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: false,
            shouldRetry: true))
    }
}


struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView: AnyObject {
    func display(_ viewModel: FeedLoadingViewModel)
}


struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}


final class FeedPresenter {

    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    
    init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }
    
    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
