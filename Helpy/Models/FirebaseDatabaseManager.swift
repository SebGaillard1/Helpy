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
    //MARK: - Singleton
    static var shared = FirebaseDatabaseManager()

    
    private let refClients = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForClients)
    private let refPros = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForProfessionals)
    private let refPosts = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForPosts)

    private init() {}
    
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
    func getRecentPosts(callback: @escaping (_ posts: [Post]) -> Void) {
//        refPosts.observe(.value) { snapshot in
//            for child in snapshot.children {
//
//            }
//        }
        
        var posts = [Post]()
        refPosts.observe(.value) { snapshot in
            let allUidSnaps = snapshot.children.allObjects as! [DataSnapshot] // Put into array to preserve order
            
            for uidSnap in allUidSnaps {
               // let uid = uidSnap.key //get uid for each child
                posts.append(Post(title: uidSnap.childSnapshot(forPath: "title").value as? String ?? "N/A",
                                  category: uidSnap.childSnapshot(forPath: "category").value as? String ?? "N/A",
                                  locality: uidSnap.childSnapshot(forPath: "locality").value as? String ?? "N/A",
                                  postalCode: uidSnap.childSnapshot(forPath: "postalCode").value as? String ?? "N/A",
                                  postDate: uidSnap.childSnapshot(forPath: "postDate").value as? Date ?? Date(),
                                  proUid: uidSnap.childSnapshot(forPath: "proUid").value as? String ?? "N/A",
                                  description: uidSnap.childSnapshot(forPath: "description").value as? String ?? "N/A",
                                  imageUrl: uidSnap.childSnapshot(forPath: "imageUrl").value as? String ?? "N/A",
                                  isOnline: uidSnap.childSnapshot(forPath: "isOnline").value as? Bool ?? false))
            }
            callback(posts)
        }
    }
}
