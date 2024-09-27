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
        let (_, view) = makeSUT()
        
        XCTAssert(view.messages.isEmpty)
    }
    
    // MARK: Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        checkForMemoryLeaks(view, file: file, line: line)
        checkForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
}
