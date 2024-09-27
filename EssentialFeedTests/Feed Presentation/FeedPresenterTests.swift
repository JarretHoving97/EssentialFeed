//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 27/09/2024.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssert(view.messages.isEmpty)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
