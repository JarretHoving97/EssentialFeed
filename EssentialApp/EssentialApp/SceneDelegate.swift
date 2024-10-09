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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // Create the window using the windowScene
        let window = UIWindow(windowScene: scene)

        self.window = window
        self.window?.makeKeyAndVisible()
    }
}
