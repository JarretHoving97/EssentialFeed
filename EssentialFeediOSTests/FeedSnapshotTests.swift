//
//  FeedSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Jarret Hoving on 15/10/2024.
//

import XCTest
import EssentialFeediOS

class FeedSnapshotTests: XCTestCase {
    
    func test_empty_feed() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())
    
        record(snapshot: sut.snapshot(), named: "EMPTY_FEED")
        
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FeedViewController
        
        controller.loadViewIfNeeded()
        
        return controller
    }
    
    func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData =  snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }
        
        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            
            try snapshotData.write(to: snapshotURL)
            
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    func emptyFeed() -> [FeedImageCellController] {
        return []
    }
    
}

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}
