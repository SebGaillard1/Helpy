//
//  FirebaseDatabaseManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import Foundation
import Firebase

class FirebaseDatabaseManager {
    let ref = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForClients)
    
    func saveClient(lastName: String, firstName: String, authResult: AuthDataResult?, completion: @escaping (_ error: String?) -> Void) {
        guard let authResult = authResult else {
            completion("Une erreur est survenue lors de la création de votre compte.")
            return
        }
        
        let client = Client(lastName: lastName, firstName: firstName, email: authResult.user.email!, uid: authResult.user.uid, key: "")
        let clientRef = ref.child(client.uid)
        
        clientRef.setValue(client.toAnyObject()) { error, _ in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
}
