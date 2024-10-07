//
//  XCTestCase+MemoryLeakTrackingHelper.swift
//  EssentialAppTests
//
//  Created by Jarret Hoving on 07/10/2024.
//

import XCTest


extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential Memory Leak.", file: file, line: line)
        }
    }
}
