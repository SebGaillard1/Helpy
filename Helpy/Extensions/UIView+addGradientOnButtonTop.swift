//
//  UIView+addGradientOnButtonTop.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 06/03/2022.
//

import Foundation
import UIKit

extension UIView {
    func addGradientOnButtonTop(buttonContainerView: UIView) {
        let height = 3.0
        let lineView = UIView(frame: CGRect(x: 0, y: self.bounds.height - buttonContainerView.bounds.height - height, width: buttonContainerView.bounds.width, height: height))
        let gradient = CAGradientLayer()
        gradient.frame = lineView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.1).cgColor]
        lineView.layer.insertSublayer(gradient, at: 0)
        self.addSubview(lineView)
    }
}
