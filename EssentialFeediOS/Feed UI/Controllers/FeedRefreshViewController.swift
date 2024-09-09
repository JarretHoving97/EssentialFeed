//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 09/08/2024.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {


    public lazy var view: UIRefreshControl = loadView()
    
    let loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
    }

    public func loadView() -> UIRefreshControl{
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
}

