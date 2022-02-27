//
//  ProSignUpViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import UIKit
import Firebase

class ProSignUpViewController: UIViewController, JobsTableViewControllerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var chooseJobButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    //MARK: - Properties
    let segueToJobs = "proSignUpToJobs"
    let segueToSuccess = "proSignUpToProHome"
    
    var defaultButtonTitle: String?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.hideKeyboardOnTap()

        defaultButtonTitle = chooseJobButton.title(for: .normal)
    }
    
    @IBAction func createAccountDidTouch(_ sender: Any) {
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
        
        if chooseJobButton.title(for: .normal) == defaultButtonTitle || chooseJobButton.title(for: .normal) == "" {
            errorLabel.text = "Veuillez choisir votre métier."
            return
        }
        
        guard let job = chooseJobButton.title(for: .normal) else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error, authResult == nil {
                self.errorLabel.text = error.localizedDescription
                return
            }
            
            FirebaseDatabaseManager.shared.saveProfessional(lastName: lastName, firstName: firstName, job: job, authResult: authResult) { error in
                if let error = error {
                    self.errorLabel.text = error
                    return
                }
                
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error, authResult == nil {
                        self.errorLabel.text = error.localizedDescription
                    } else {
                        self.performSegue(withIdentifier: self.segueToSuccess, sender: self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToJobs {
            let destinationVC = segue.destination as! JobsTableViewController
            destinationVC.delegate = self
        }
    }

    @IBAction func chooseJobDidTouch(_ sender: Any) {
        performSegue(withIdentifier: segueToJobs, sender: self)
    }
    
    internal func sendJobSelected(job: String) {
        chooseJobButton.setTitle(job, for: .normal)
    }
}