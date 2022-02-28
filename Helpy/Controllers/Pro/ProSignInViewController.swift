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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInDidTouch(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        FirebaseAuthManager.shared.signInPro(withEmail: email, password: password) { connected, error in
            if connected && error == nil {
                self.performSegue(withIdentifier: self.segueIdToProHome, sender: self)
            } else {
                self.errorLabel.text = "Impossible de se connecter"
            }
        }
    }
}
