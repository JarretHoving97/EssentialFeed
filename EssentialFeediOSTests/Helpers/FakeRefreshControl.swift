//
//  FakeRefreshControl.swift
//  EssentialFeediOSTests
//
//  Created by Jarret Hoving on 06/08/2024.
//

import UIKit.UIRefreshControl

class FakeRefreshControl: UIRefreshControl {
    
    private var _isRefreshing = false
    
    override var isRefreshing: Bool {
       return  _isRefreshing
    }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
