//
//  FirebaseDatabaseManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import Foundation
import Firebase
import UIKit

class FirebaseDatabaseManager {
    let refClients = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForClients)
    let refPros = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForProfessionals)
    let refPosts = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForPosts)


    
    func saveClient(lastName: String, firstName: String, adress: String, authResult: AuthDataResult?, completion: @escaping (_ error: String?) -> Void) {
        guard let authResult = authResult else {
            completion("Une erreur est survenue lors de la création de votre compte.")
            return
        }
        
        let client = Client(lastName: lastName, firstName: firstName, adress: adress, email: authResult.user.email!, uid: authResult.user.uid, key: "")
        let clientRef = refClients.child(client.uid)
        
        clientRef.setValue(client.toAnyObject()) { error, _ in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func saveProfessional(lastName: String, firstName: String, job: String, authResult: AuthDataResult?, completion: @escaping (_ error: String?) -> Void) {
        guard let authResult = authResult else {
            completion("Une erreur est survenue lors de la création de votre compte.")
            return
        }
        
        let professional = Professional(lastName: lastName, firstName: firstName, email: authResult.user.email!, job: job, uid: authResult.user.uid, key: "")
        let professionalRef = refPros.child(professional.uid)
        
        professionalRef.setValue(professional.toAnyObject()) { error, _ in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func savePost(title: String, category: String, locality: String, postalCode: String, postDate: Date, proUid: String, description: String, imageUrl: String, isOnline: Bool, completion: @escaping (_ error: String?) -> Void) {
        let post = Post(title: title, category: category, locality: locality, postalCode: postalCode, postDate: postDate, proUid: proUid, description: description, imageUrl: imageUrl, isOnline: isOnline)
        let postRef = refPosts.childByAutoId()
        
        postRef.setValue(post.toAnyObject()) { error, _ in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    // When we save a post, the key generated is unique and based on horodatage. So the post's list is in chronological order by default
    func getRecentPosts() {
        refPosts.observe(.value) { snapshot in
            print(snapshot.value as Any)
        }
    }
}
