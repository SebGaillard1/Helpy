//
//  UIImageView+roundedCorners.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func roundedCorners() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
}
