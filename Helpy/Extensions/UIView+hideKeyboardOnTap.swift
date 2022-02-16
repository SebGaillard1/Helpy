//
//  UIView+hideKeyboardOnTap.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/02/2022.
//

import Foundation
import UIKit

extension UIView {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
    }
}
