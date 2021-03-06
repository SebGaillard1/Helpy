//
//  ProSignInViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 17/02/2022.
//

import UIKit

class ProSignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let segueIdToProHome = "proSignInToProHome"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func signInDidTouch(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        
        FirebaseAuthManager.shared.signInUser(userType: .pro, withEmail: email, password: password) { error in
            if error == nil {
                self.performSegue(withIdentifier: self.segueIdToProHome, sender: self)
                self.errorLabel.isHidden = true
            } else {
                self.errorLabel.text = error
                self.errorLabel.isHidden = false
            }
        }
    }
}
