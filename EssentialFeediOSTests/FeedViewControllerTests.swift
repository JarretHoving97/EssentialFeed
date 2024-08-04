//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Jarret Hoving on 04/08/2024.
//

import XCTest
import UIKit

final class FeedViewController: UIViewController {
    
    
    var loader: FeedViewControllerTests.loaderSpy?
    
    convenience init(loader: FeedViewControllerTests.loaderSpy) {
        self.init()
        self.loader = loader
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load()
    }

}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = loaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    
    func test_viewDidLoad_loadsFeed() {
        let loader = loaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
        
    }
    
    // MARK: Helpers
    class loaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }

}
