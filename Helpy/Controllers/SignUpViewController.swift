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
    
    let ref = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForClients)
    
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
        // 1
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
        
        // 2
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // 3
            if authResult != nil && error == nil {
                self.addClient(lastName: lastName, firstName: firstName, authResult: authResult!) { error in
                    if error == nil {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error, authResult == nil {
                                self.errorLabel.text = error.localizedDescription
                            } else {
                                self.performSegue(withIdentifier: self.signUpToSuccess, sender: self)
                            }
                        }
                    } else {
                        self.errorLabel.text = error?.localizedDescription
                    }
                }
            } else {
                self.errorLabel.text =  "\(error?.localizedDescription ?? "Impossible de créer le compte")"
            }
        }
    }
    
    func addClient(lastName: String, firstName: String, authResult: AuthDataResult, completion: @escaping (_ error: Error?) -> Void) {
        let client = Client(lastName: lastNameTextField.text!, firstName: firstNameTextField.text!, email: authResult.user.email!, uid: authResult.user.uid, key: "")
        
        let clientRef = ref.child(client.uid)
        clientRef.setValue(client.toAnyObject()) { error, _ in
            completion(error)
        }
    }
}


