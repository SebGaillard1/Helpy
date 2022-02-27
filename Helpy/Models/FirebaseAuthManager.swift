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
    
    var handle: AuthStateDidChangeListenerHandle?

    private init() {}
    
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
    
    func signInPro(withEmail email: String, password: String, completion: @escaping (_ connected: Bool, _ error: Error?) -> Void) {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    self.handle = Auth.auth().addStateDidChangeListener { _, user in
                      // 2
                        guard let user = user else {
                            completion(false, nil)
                            return
                        }
                        
                        Constants.FirebaseHelper.clientRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                            if querySnapshot?.isEmpty == true && error == nil {
                                print("Vous essayez de vous connecter avec un compte client")
                                completion(false, nil)
                            }
                        }
                        
                        Constants.FirebaseHelper.proRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                            if querySnapshot?.isEmpty == false && error == nil {
                                completion(true, nil)
                            }
                        }
                        
//                        self.clientRef.observe(.value) { snapshot in
//                            print("Vous essayez de vous connecter avec un compte client")
//                            completion(false, nil)
//                        }
//
//                        self.proRef.observe(.value) { snapshot in
//                            if snapshot.hasChild(user.uid) {
//                                print("Devrait etre connecté")
//                                completion(true, nil)
//                            }
//                        }
                    }
                }
    }
}
