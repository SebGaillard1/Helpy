//
//  ViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
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
        // 1
        handle = Auth.auth().addStateDidChangeListener { _, user in
          // 2
            guard let user = user else {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            
            Constants.FirebaseHelper.clientRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                if querySnapshot?.isEmpty == false && error == nil {
                    self.performSegue(withIdentifier: self.segueIdWelcomeToClientHome, sender: nil)
                }
            }
            
            Constants.FirebaseHelper.proRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                if querySnapshot?.isEmpty == false && error == nil {
                    self.performSegue(withIdentifier: self.segueIdWelcomeToProHome, sender: nil)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
