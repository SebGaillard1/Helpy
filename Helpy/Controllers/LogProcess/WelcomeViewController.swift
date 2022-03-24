//
//  ViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase
import AVFoundation

class WelcomeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    //MARK: - Properties
    var handle: AuthStateDidChangeListenerHandle?
    
    let segueIdWelcomeToClientHome = "welcomeToClientHome"
    let segueIdWelcomeToProHome = "welcomeToProHome"

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.isHidden = false
        
        // 1
        handle = Auth.auth().addStateDidChangeListener { _, user in
          // 2
            guard let user = user else {
                self.navigationController?.popToRootViewController(animated: true)
                self.backgroundImageView.isHidden = true
                self.logoImageView.isHidden = true
                return
            }
            
            Constants.FirebaseHelper.clientRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                if querySnapshot?.isEmpty == false && error == nil {
                    UIView.setAnimationsEnabled(false)
                    self.performSegue(withIdentifier: self.segueIdWelcomeToClientHome, sender: nil)
                }
            }
            
            Constants.FirebaseHelper.proRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                if querySnapshot?.isEmpty == false && error == nil {
                    UIView.setAnimationsEnabled(false)
                    self.performSegue(withIdentifier: self.segueIdWelcomeToProHome, sender: nil)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.hideImages()
        UIView.setAnimationsEnabled(true)
        
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
