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
            
            let ref = self.db.collection("posts").addDocument(data: post.toDictionnary()) { error in
                if let error = error {
                    completion(error.localizedDescription)
                } else {
                    completion(nil)
                }
            }
            // Add time
            ref.updateData(["postDate": FieldValue.serverTimestamp()])
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
    
    func getPostByLocation(center: CLLocationCoordinate2D, radiusInMeters: CLLocationDistance, completion: @escaping (_ posts: [Post]) -> Void) {
        // Each item in 'bounds' represents a startAt/endAt pair. We have to issue
        // a separate query for each pair. There can be up to 9 pairs of bounds
        // depending on overlap, but in most cases there are 4.
        let queryBounds = GFUtils.queryBounds(forLocation: center, withRadius: radiusInMeters)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("posts")
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
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
