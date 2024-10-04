//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Jarret Hoving on 02/10/2024.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // Create the window using the windowScene
        let window = UIWindow(windowScene: scene)
        
        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let feedLoader = RemoteFeedLoader(url: url, client: client)
        let imageLoader = RemoteFeedImageDataLoader(client: client)
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: feedLoader,
            imageLoader: imageLoader
        )
        
        window.rootViewController = feedViewController
        
        window.makeKeyAndVisible()
    }
}
