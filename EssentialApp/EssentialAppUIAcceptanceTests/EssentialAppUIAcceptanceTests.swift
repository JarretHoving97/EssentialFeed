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
        
        XCTAssertEqual(app.cells.count, 22)
        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }
}
