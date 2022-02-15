//
//  NewPostPostedSuccessfullyViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import UIKit
import SwiftConfettiView

class NewPostPostedSuccessfullyViewController: UIViewController {
    var confettiView: SwiftConfettiView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
        confettiView = SwiftConfettiView(frame: self.view.bounds)
        confettiView?.intensity = 1
        self.view.addSubview(confettiView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        confettiView?.startConfetti()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        confettiView?.stopConfetti()
    }
}
