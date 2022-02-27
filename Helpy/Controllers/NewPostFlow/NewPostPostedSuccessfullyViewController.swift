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
    var feedbackGenerator: UINotificationFeedbackGenerator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true

        confettiView = SwiftConfettiView(frame: self.view.bounds)
        confettiView?.intensity = 1
        self.view.addSubview(confettiView!)
        
        feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        confettiView?.startConfetti()
        feedbackGenerator?.notificationOccurred(.success)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        confettiView?.stopConfetti()
        feedbackGenerator = nil
    }
}
