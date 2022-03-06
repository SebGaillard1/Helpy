//
//  UIViewController+addSeparator.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 04/03/2022.
//

import Foundation
import UIKit

extension UIView {
    func addSeparator(x: Double, y: Double) {
        let lineView = UIView(frame: CGRect(x: x, y: y, width: self.bounds.width, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.systemGray5.cgColor
        self.addSubview(lineView)
    }
}

