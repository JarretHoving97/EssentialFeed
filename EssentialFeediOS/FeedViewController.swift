//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 08/08/2024.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController {
    
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    public var loader: FeedLoader?
    private var tableModel = [FeedImage]()
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewIsAppearing = { vc in
            vc.onViewIsAppearing = nil
            vc.load()
        }
        
        title = "My Feed"
    }
    
    public  override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        onViewIsAppearing?(self)
    }

    @objc public func load() {
        refreshControl?.beginRefreshing()
        
        loader?.load { [weak self] result in
            guard let self else { return }
            self.tableModel = (try? result.get()) ?? []
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        
        return cell
    }
}
