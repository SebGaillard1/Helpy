//
//  SignUpViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Properties
    let signUpToSuccess = "signUpToSuccess"
    
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // 1
//        handle = Auth.auth().addStateDidChangeListener { _, user in
//            // 2
//            if user == nil {
//                self.navigationController?.popToRootViewController(animated: true)
//            } else {
//                // 3
//                self.performSegue(withIdentifier: self.signUpToSuccess, sender: nil)
//                self.emailTextField.text = nil
//                self.passwordTextField.text = nil
//                self.passwordConfirmationTextField.text = nil
//            }
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        guard let handle = handle else { return }
//        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //MARK: - Actions
    @IBAction func signUpDidTouch(_ sender: Any) {
        // 1
        if passwordTextField.text != passwordConfirmationTextField.text {
            errorLabel.text = "Password and confirmation are not matching!"
            return
        }
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else { return }
        
        // 2
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            // 3
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password) { user, error in
                    if let error = error, user == nil {
                        self.errorLabel.text = error.localizedDescription
                    } else {
                        self.performSegue(withIdentifier: self.signUpToSuccess, sender: self)
                    }
                }
            } else {
                self.errorLabel.text =  "\(error?.localizedDescription ?? "Impossible de créer le compte")"
            }
        }
    }
}
