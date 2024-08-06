//
//  UITableView+iOS17RefreshControlExtension.swift
//  EssentialFeediOSTests
//
//  Created by Jarret Hoving on 06/08/2024.
//

import UIKit.UITableViewController

extension UITableViewController {
   
   func replaceRefreshControlWithFakeiOS17Support() {
       let fake = FakeRefreshControl()

       refreshControl?.allTargets.forEach { target in
           refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
               fake.addTarget(target, action: Selector(action), for: .valueChanged)
           }
       }
       refreshControl = fake
   }
}
