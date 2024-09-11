//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 11/09/2024.
//

import UIKit.UITableView


extension UITableView {
    
    func dequeueRusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
