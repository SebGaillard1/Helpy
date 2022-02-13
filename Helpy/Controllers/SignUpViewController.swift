//
//  SignUpViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase

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
    
    //let ref = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForClients)
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Actions
    @IBAction func signUpDidTouch(_ sender: Any) {
        if passwordTextField.text != passwordConfirmationTextField.text {
            errorLabel.text = "Le mot de passe et sa confirmation ne correspondent pas."
            return
        }
        
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            errorLabel.text = "Votre nom et prénom ne peuvent être vides."
            return
        }
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            errorLabel.text = "L'adresse mail et/ou le mot de passe ne peuvent être vides."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error, authResult == nil {
                self.errorLabel.text = error.localizedDescription
                return
            }
            
            FirebaseDatabaseManager().saveClient(lastName: lastName, firstName: firstName, authResult: authResult) { error in
                if let error = error {
                    self.errorLabel.text = error
                    return
                }
                
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error, authResult == nil {
                        self.errorLabel.text = error.localizedDescription
                    } else {
                        self.performSegue(withIdentifier: self.signUpToSuccess, sender: self)
                    }
                }
            }
        }
    }
}


