//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Jarret Hoving on 09/10/2024.
//

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {
    
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        
        let app = XCUIApplication()
        
        app.launch()
        
        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        
        XCTAssertEqual(feedCells.count, 22)
        XCTAssertTrue(firstImage.exists)
    }
}
