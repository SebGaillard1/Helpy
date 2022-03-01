//
//  FirebaseDatabaseManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import Foundation
import Firebase
import Alamofire
import UIKit

class FirebaseDatabaseManager {
    //MARK: - Singleton
    static var shared = FirebaseDatabaseManager()
    
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    
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
        let image = post.image ?? UIImage(named: "garde-enfant")!
        
        savePostImage(image: image) { imageDowndloadLink, error in
            guard !imageDowndloadLink.isEmpty, error == nil else {
                // Failed to save or get the image url
                completion(error)
                return
            }
            
            var post = post
            post.imageUrl = imageDowndloadLink
            
            self.db.collection("posts").addDocument(data: post.toDictionnary()) { error in
                if let error = error {
                    completion(error.localizedDescription)
                } else {
                    completion(nil)
                }
            }
        }
        
        
    }
    
    func savePostImage(image: UIImage, completion: @escaping (_ imageDowndloadLink: String, _ error: String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            completion("", "Failed to get jpeg data")
            return
        }
        
        let path = "images/\(UUID().uuidString)/image.jpeg"
        let ref = storageRef.child(path)
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion("", error.localizedDescription)
            } else {
                self.storageRef.child(path).downloadURL { url, error in
                    guard let url = url, error == nil else {
                        completion("", error?.localizedDescription)
                        return
                    }
                    completion(url.absoluteString, nil)
                }
            }
        }
    }
    
    // When we save a post, the key generated is unique and based on horodatage. So the post's list is in chronological order by default
    func getRecentPosts(completion: @escaping (_ posts: [Post]) -> Void) {
        var posts = [Post]()
        
        db.collection("posts").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                completion([])
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    if let newPost = Post(dictionnary: diff.document.data()) {
                        posts.append(newPost)
                    }
                }
            }
            
            completion(posts.reversed())
        }
    }
    
    func getPostFrom(pro: String, completion: @escaping (_ posts : [Post]) -> Void) {
        var posts = [Post]()
        
        db.collection("posts").whereField("proUid", isEqualTo: pro).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                completion([])
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    if let newPost = Post(dictionnary: diff.document.data()) {
                        posts.append(newPost)
                    }
                }
            }
            
            completion(posts.reversed())
        }
    }
    
    
    func downloadImage(from url: String, completion: @escaping (_ postImage: UIImage) -> Void) {
        AF.request(url).responseData { response in
            if response.error == nil {
                if let data = response.data {
                    completion(UIImage(data: data) ?? UIImage(named: "placeholder-purple")!)
                }
            } else {
                completion(UIImage(named: "placeholder-purple")!)
            }
        }
    }
}
