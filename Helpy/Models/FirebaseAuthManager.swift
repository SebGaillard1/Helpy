//
//  FirebaseAuthManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    func createUser(withEmail email: String, password: String, completion: @escaping (_ authResult: AuthDataResult?, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error, authResult == nil {
                completion(nil, error)
            } else {
                completion(authResult, nil)
            }
        }
    }
    
    func signInUser(withEmail email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error, authResult == nil {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
