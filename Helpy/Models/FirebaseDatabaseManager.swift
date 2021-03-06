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
import CoreLocation
import GeoFire

final class FirebaseDatabaseManager {
    //MARK: - Singleton
    static var shared = FirebaseDatabaseManager()
    
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    
    private init() {}
    
    func saveUser(userType: UserType, lastName: String, firstName: String, authResult: AuthDataResult?, completion: @escaping (_ error: String?) -> Void) {
        guard let authResult = authResult else {
            completion("Une erreur est survenue lors de la création de votre compte.")
            return
        }
        
        switch userType {
        case .client:
            let client = Client(lastName: lastName, firstName: firstName, email: authResult.user.email!, uid: authResult.user.uid)
            
            db.collection("clients").addDocument(data: client.toDictionnary()) { error in
                error != nil ? completion(error?.localizedDescription ?? "Impossible de créer le compte") : completion(nil)
            }
        case .pro:
            let professional = Professional(lastName: lastName, firstName: firstName, email: authResult.user.email!, uid: authResult.user.uid)
            
            db.collection("professionals").addDocument(data: professional.toDictionnary()) { error in
                error != nil ? completion(error?.localizedDescription ?? "Impossible de créer le compte") : completion(nil)
            }
        }
    }
    
    func getProName(forUid uid: String, completion: @escaping (_ name: String?) -> Void) {
        db.collection("professionals").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            guard error == nil,
                  let snapshot = snapshot,
                  !snapshot.documents.isEmpty,
                  let name = snapshot.documents[0]["firstName"] as? String else {
                completion(nil)
                return
            }
            
            completion(name)
        }
    }
    
    func saveUserNameToUserDefaults(userType: UserType) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        var collectionName = ""
        if userType == .client {
            collectionName = "clients"
        } else {
            collectionName = "professionals"
        }
        
        db.collection(collectionName).whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            guard error == nil,
                  snapshot?.isEmpty == false,
                  let doc = snapshot?.documents[0],
                  let name = doc["firstName"] as? String else {
                return
            }
            
            UserDefaults.standard.set(name, forKey: "username")
        }
    }
    
    func savePost(post: Post, completion: @escaping (_ error: String?) -> Void) {
        let image = post.image ?? UIImage(named: "garde-enfant")!
        
        savePostImage(image: image) { imageDowndloadLink, error in
            guard !imageDowndloadLink.isEmpty, error == nil else {
                completion(error)
                return
            }
            
            var post = post
            post.imageUrl = imageDowndloadLink
            
            let ref = self.db.collection("posts").addDocument(data: post.toDictionnary()) { error in
                if let error = error {
                    completion(error.localizedDescription)
                    return
                }
            }
            
            // Add time
            ref.updateData(["postDate": FieldValue.serverTimestamp()]) { error in
                error == nil ? completion(nil) : completion(error?.localizedDescription ?? "Impossible d'enregistrer l'heure de publication")
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
            //            if let error = error {
            //                print(error)
            //                completion("", error.localizedDescription)
            //} else {
            self.storageRef.child(path).downloadURL { url, error in
                guard let url = url, error == nil else {
                    completion("", error?.localizedDescription)
                    return
                }
                completion(url.absoluteString, nil)
            }
            //}
        }
    }
    
    // When we save a post, the key generated is unique and based on horodatage. So the post's list is in chronological order by default
    func getRecentPosts(completion: @escaping (_ posts: [Post]) -> Void) {
        var posts = [Post]()
        
        db.collection("posts").order(by: "postDate", descending: false).addSnapshotListener { snapshot, error in
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
            
            snapshot.documents.forEach { doc in
                if let newPost = Post(dictionnary: doc.data()) {
                    posts.append(newPost)
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
    
    func getPostByLocation(category: String, center: CLLocationCoordinate2D, radiusInMeters: CLLocationDistance, completion: @escaping (_ posts: [Post]) -> Void) {
        // Each item in 'bounds' represents a startAt/endAt pair. We have to issue
        // a separate query for each pair. There can be up to 9 pairs of bounds
        // depending on overlap, but in most cases there are 4.
        let queryBounds = GFUtils.queryBounds(forLocation: center, withRadius: radiusInMeters)
        let queries = queryBounds.map { bound -> Query in
            if category != ""{
                return db.collection("posts")
                    .whereField("category", isEqualTo: category.capitalized)
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
            } else {
                return db.collection("posts")
                    .order(by: "geohash")
                    .start(at: [bound.startValue])
                    .end(at: [bound.endValue])
            }
        }
        
        var matchingDocs = [QueryDocumentSnapshot]()
        let myGroup = DispatchGroup()
        // Collect all the query results together into a single list
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                completion([])
                return
            }
            
            for document in documents {
                let lat = document.data()["latitude"] as? Double ?? 0
                let lng = document.data()["longitude"] as? Double ?? 0
                let coordinates = CLLocation(latitude: lat, longitude: lng)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                
                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                if distance <= radiusInMeters {
                    matchingDocs.append(document)
                }
            }
            myGroup.leave()
        }
        
        // After all callbacks have executed, matchingDocs contains the result.
        // We wait for all callbacks to finish
        for query in queries {
            myGroup.enter()
            query.getDocuments(completion: getDocumentsCompletion)
        }
        
        myGroup.notify(queue: .main) {
            var posts = [Post]()
            for docSnap in matchingDocs {
                if let post = Post(snapshot: docSnap) {
                    posts.append(post)
                }
            }
            completion(posts)
        }
    }
}
