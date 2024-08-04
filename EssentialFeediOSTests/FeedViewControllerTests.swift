//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Jarret Hoving on 04/08/2024.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UIViewController {
    
    var loader: FeedLoader?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load { _ in }
    }

}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = loaderSpy()
        let _ = FeedViewController()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = loaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: Helpers
    
    class loaderSpy: FeedLoader {
  
        private(set) var loadCallCount: Int = 0
         
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}
