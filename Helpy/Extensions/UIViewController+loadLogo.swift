//
//  UIViewController+loadLogo.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 02/03/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func loadLogo() {
        let imageView = UIImageView(image: UIImage(named: "logo.png"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
}
