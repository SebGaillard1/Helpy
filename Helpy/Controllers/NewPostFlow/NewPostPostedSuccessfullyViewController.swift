//
//  NewPostPostedSuccessfullyViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import UIKit
import SwiftConfettiView

class NewPostPostedSuccessfullyViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var confettiUIView: UIView!
    
    //MARK: - Properties
    var confettiView: SwiftConfettiView?
    var feedbackGenerator: UINotificationFeedbackGenerator?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true

        confettiView = SwiftConfettiView(frame: self.view.bounds)
        confettiView?.intensity = 1
        self.confettiUIView.addSubview(confettiView!)
        
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
    
    @IBAction func goHomeDidTouch(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is ProTapBarViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
}
