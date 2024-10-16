//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Jarret Hoving on 02/10/2024.
//

import UIKit
import Combine
import CoreData
import EssentialFeed
import EssentialFeediOS


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
    
    private lazy var remoteFeedLoader = RemoteFeedLoader(url: url, client: httpClient)
    
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathExtension("feed-store.sqlite")

    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite"))
    }()

    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()      
    }
    
    func configureWindow() {
    
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedComposedWith(
                feedLoader: makeRemoteFeedLoaderWithLocalFallBack,
                imageLoader: makeLocalImageLoaderWithRemoteFallBack
            )
        )
        
        window?.makeKeyAndVisible()
      
    }
    
     func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
    
    private func makeRemoteFeedLoaderWithLocalFallBack() -> FeedLoader.Publisher {

        return remoteFeedLoader
            .loadPublisher()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    private func makeLocalImageLoaderWithRemoteFallBack(url: URL) -> FeedImageDataLoader.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisherFrom(url: url)
            .fallback {
                remoteImageLoader
                    .loadImageDataPublisherFrom(url: url)
                    .caching(to: localImageLoader, using: url)
            }
    }
}
