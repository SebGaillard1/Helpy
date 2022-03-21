//
//  FirebaseAuthManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import Foundation
import Firebase

class FirebaseAuthManager {
    //MARK: - Properties
    static let shared = FirebaseAuthManager()
    
    //var handle: AuthStateDidChangeListenerHandle?
    
    private init() {}
    
    func createUser(userType: UserType, withEmail email: String, password: String, lastName: String?, firstName: String?, completion: @escaping (_ authResult: AuthDataResult?, _ error: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error, authResult == nil {
                completion(nil, error.localizedDescription)
            } else {
                if userType == .pro {
                    FirebaseDatabaseManager.shared.saveProfessional(lastName: lastName ?? "", firstName: firstName ?? "", authResult: authResult) { error in
                        if let error = error {
                            completion(nil, error)
                        } else {
                            completion(authResult, nil)
                        }
                    }
                } else {
                    completion(authResult, nil)
                }
            }
        }
    }
    
    func signInUser(userType: UserType, withEmail email: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let authResult = authResult, error == nil else {
                completion(error?.localizedDescription ?? "Compte introuvable")
                return
            }
            
            switch userType {
            case .client:
                Constants.FirebaseHelper.clientRef.whereField("uid", isEqualTo: authResult.user.uid).getDocuments { querySnapshot, error in
                    if querySnapshot?.isEmpty == true && error == nil {
                        do {
                            try Auth.auth().signOut()
                        } catch let error {
                            print("Auth sign out failed: \(error)")
                        }
                        completion("Compte introuvable")
                    } else {
                        completion(nil)
                    }
                }
            case .pro:
                Constants.FirebaseHelper.proRef.whereField("uid", isEqualTo: authResult.user.uid).getDocuments { querySnapshot, error in
                    if querySnapshot?.isEmpty == true && error == nil {
                        do {
                            try Auth.auth().signOut()
                        } catch let error {
                            print("Auth sign out failed: \(error)")
                        }
                        completion("Compte introuvable")
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
}
