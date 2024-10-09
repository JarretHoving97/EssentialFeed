//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Jarret Hoving on 02/10/2024.
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathExtension("feed-store.sqlite")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // Create the window using the windowScene
        let window = UIWindow(windowScene: scene)
        
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        
        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: url, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        window.rootViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallBackComposite(
                primaryLoader: FeedLoaderCacheDecorator(
                    decoratee: remoteFeedLoader,
                    cache: localFeedLoader
                ),
                fallBackLoader: localFeedLoader
            ),
            imageLoader: FeedImageDataLoaderWithFallBackComposite(
                primary: localImageLoader,
                fallback: FeedImageDataLoaderCacheDecorator(
                    loader: remoteImageLoader,
                    cache: localImageLoader
                )
            )
        )
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    
     func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
}

