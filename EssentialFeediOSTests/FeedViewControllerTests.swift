//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Jarret Hoving on 04/08/2024.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    var loader: FeedLoader?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewIsAppearing = { vc in
            vc.onViewIsAppearing = nil
            vc.load()
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        onViewIsAppearing?(self)
    }

    @objc private func load() {
        
        refreshControl?.beginRefreshing()
        
        loader?.load { [weak self] _ in
            guard let self else { return }
            self.refreshControl?.endRefreshing()
        }
    }
}


private extension FeedViewController {
    
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            replaceRefreshControlWithFakeiOS17Support()
        }
        
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded.")
        
        sut.simulateAppearance()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading requesat once view is loaded.")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load.")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "expected a third loading request once user initiates another load.")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()

        XCTAssertTrue(sut.isShowingIndicator, "Expected loading indicator once view is loaded.")

        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingIndicator, "Expected no loading indicator once loading is completed")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingIndicator, "Expected loading indicator once user initiates a reload")
        
        sut.simulateUserInitiatedFeedReload()
        
        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (FeedViewController, loaderSpy) {
        let loader = loaderSpy()
        let sut = FeedViewController(loader: loader)
        checkForMemoryLeaks(loader, file: file, line: line)
        checkForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    class loaderSpy: FeedLoader {
        
        private var completions = [(FeedLoader.Result) -> Void]()
        
        var loadCallCount: Int {
          return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private extension FeedViewController {
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}


private extension UIRefreshControl {
    
    func simulatePullToRefresh() {
        beginRefreshing()
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
