//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOSTests
//
//  Created by Jarret Hoving on 15/10/2024.
//

import UIKit

extension UITableView {
    func sizeHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let needsFrameUpdate = header.frame.height != size.height
        
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
