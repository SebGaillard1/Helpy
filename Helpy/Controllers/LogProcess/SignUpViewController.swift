//
//  SignUpViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase
import GooglePlaces

class SignUpViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Properties
    let signUpToSuccess = "signUpToHome"
    
    //var handle: AuthStateDidChangeListenerHandle?
    
    //let ref = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForClients)
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Actions
    
    @IBAction func addressTextFieldTouchDown(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify a filter
        let filter = GMSAutocompleteFilter()
        filter.country = "FR"
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Place data to return
        let fields: GMSPlaceField = [.formattedAddress, .addressComponents, .coordinate]
        autocompleteController.placeFields = fields
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
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
            
            FirebaseDatabaseManager.shared.saveClient(lastName: lastName, firstName: firstName, adress: self.adressTextField.text!, authResult: authResult) { error in
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

extension SignUpViewController: GMSAutocompleteViewControllerDelegate {
  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      //print(place.formattedAddress)
      //print(place.addressComponents)
      print(place.coordinate.latitude)
      print(place.coordinate.longitude)
      guard let components = place.addressComponents else { return }
      for component in components {
          for type in component.types {
              switch type {
              case "locality":
                  print(component.name)
              case "postal_code":
                  print(component.name)
              default:
                  break
              }
          }
      }
      
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
}

