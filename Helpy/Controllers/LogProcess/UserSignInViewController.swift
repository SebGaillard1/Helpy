//
//  SignInViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase

class UserSignInViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Properties
    let signInToSuccess = "signInToHome"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        signInButton.isEnabled = true
    }
    
    //MARK: - Actions
    @IBAction func signInDidTouch(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            errorLabel.text = "Le mot de passe ou l'e-mail ne peuvent être vide"
            errorLabel.isHidden = false
            return
        }
        sender.isEnabled = false
        activityIndicator.isHidden = false
        
        FirebaseAuthManager.shared.signInUser(userType: .client, withEmail: email, password: password) { error in
            if error == nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: self.signInToSuccess, sender: self)
            } else {
                self.errorLabel.text = error
                self.errorLabel.isHidden = false
                sender.isEnabled = true
            }
            self.activityIndicator.isHidden = true
        }
    }
}
