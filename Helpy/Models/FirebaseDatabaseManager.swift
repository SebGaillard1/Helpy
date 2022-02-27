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

    private let db = Firestore.firestore()

    private init() {}
    
    func saveClient(lastName: String, firstName: String, adress: String, authResult: AuthDataResult?, completion: @escaping (_ error: String?) -> Void) {
        guard let authResult = authResult else {
            completion("Une erreur est survenue lors de la création de votre compte.")
            return
        }
        
        let client = Client(lastName: lastName, firstName: firstName, adress: adress, email: authResult.user.email!, uid: authResult.user.uid, key: "")
        
        db.collection("clients").addDocument(data: client.toDictionnary()) { error in
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
        
        db.collection("professionals").addDocument(data: professional.toDictionnary()) { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func savePost(post: Post ,completion: @escaping (_ error: String?) -> Void) {
        db.collection("posts").addDocument(data: post.toDictionnary()) { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    // When we save a post, the key generated is unique and based on horodatage. So the post's list is in chronological order by default
    func getRecentPosts(callback: @escaping (_ posts: [Post]) -> Void) {
        var posts = [Post]()
        
        db.collection("posts").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                callback([])
                return
            }
            posts.removeAll()
            
            for document in snapshot.documents {
                posts.append(Post(title: "", category: "", locality: "", postalCode: "", postDate: Date(), proUid: "", description: "", image: nil, imageUrl: "", isOnline: true))
            }
            
//            posts = snapshot.documents.map { document in
//                return Post(title: "", category: "", locality: "", postalCode: "", postDate: Date(), proUid: "", description: "", image: nil, imageUrl: "", isOnline: true)
////                return Post(snapshot: document)!
//            }
        
//        let recentPostsQuery = refPosts.queryLimited(toLast: 20)
//
//        var posts = [Post]()
//        recentPostsQuery.observe(.value) { snapshot in
//            posts.removeAll()
//            let allUidSnaps = snapshot.children.allObjects as! [DataSnapshot] // Put into array to preserve order
//
//            for uidSnap in allUidSnaps {
//               // let uid = uidSnap.key //get uid for each child
//                posts.append(Post(title: uidSnap.childSnapshot(forPath: "title").value as? String ?? "N/A",
//                                  category: uidSnap.childSnapshot(forPath: "category").value as? String ?? "N/A",
//                                  locality: uidSnap.childSnapshot(forPath: "locality").value as? String ?? "N/A",
//                                  postalCode: uidSnap.childSnapshot(forPath: "postalCode").value as? String ?? "N/A",
//                                  postDate: uidSnap.childSnapshot(forPath: "postDate").value as? Date ?? Date(),
//                                  proUid: uidSnap.childSnapshot(forPath: "proUid").value as? String ?? "N/A",
//                                  description: uidSnap.childSnapshot(forPath: "description").value as? String ?? "N/A", image: nil,
//                                  imageUrl: uidSnap.childSnapshot(forPath: "imageUrl").value as? String ?? "N/A",
//                                  isOnline: uidSnap.childSnapshot(forPath: "isOnline").value as? Bool ?? false))
//            }
//            callback(posts.reversed())
            
       }
        
        callback(posts.reversed())
    }
}
