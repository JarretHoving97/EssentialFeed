//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 09/08/2024.
//

import UIKit

public final class FeedRefreshViewController: NSObject {
    
    public lazy var view: UIRefreshControl = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    public func binded(_ view: UIRefreshControl) -> UIRefreshControl{
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            
            isLoading ? view?.beginRefreshing() : view?.endRefreshing()
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
}

