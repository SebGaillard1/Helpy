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
            return
        }
        sender.isEnabled = false
        activityIndicator.isHidden = false
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                self.errorLabel.text = error.localizedDescription
                sender.isEnabled = true
            } else {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: self.signInToSuccess, sender: self)
            }
            self.activityIndicator.isHidden = true
        }
    }
}
