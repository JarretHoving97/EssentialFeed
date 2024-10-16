//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 08/08/2024.
//

import UIKit
import EssentialFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView, FeedErrorView {

    
    @IBOutlet private(set) public var errorView: ErrorView?
    
    private var loadingControllers = [IndexPath: FeedImageCellController]()
    
    public var delegate: FeedViewControllerDelegate?
    
    var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.prefetchDataSource = self
        
        onViewIsAppearing = { vc in
            
            vc.onViewIsAppearing = nil
            vc.refresh()
        }
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeHeaderToFit()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    
    public  override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        onViewIsAppearing?(self)
    }

    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
           cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    private func removeCellControllerLoad(forRowAt indexPath: IndexPath) {
       cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    
   public func display(_ viewModel: FeedLoadingViewModel) {
        viewModel.isLoading ? refreshControl?.beginRefreshing() : refreshControl?.endRefreshing()
    }
    
    public func display(_ cellControllers: [FeedImageCellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }
    
    public func display(_ viewModel: EssentialFeed.FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
    
}
