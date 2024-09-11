//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by Jarret Hoving on 11/09/2024.
//

import UIKit.UIImageView

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        
        image = newImage
        guard newImage != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
