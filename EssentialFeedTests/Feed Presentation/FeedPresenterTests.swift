//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Jarret Hoving on 27/09/2024.
//

import XCTest

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
    
    private let errorView: FeedErrorView
    
    init(errorView: FeedErrorView) {
        self.errorView = errorView
    }
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
  
        XCTAssert(view.messages.isEmpty)
    }
    
    func test_didStartLoadingFeed_displayErrorMessage() {
        let (sut, view) = makeSUT()
        sut.didStartLoadingFeed()
    
        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }
    
    // MARK: Helpers
    
    private class ViewSpy: FeedErrorView {
        
     
        enum Message: Equatable {
            case display(errorMessage: String?)
        }
        
       private(set) var messages = [Message]()
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.message))
        }
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(errorView: view)
        checkForMemoryLeaks(view, file: file, line: line)
        checkForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
}
