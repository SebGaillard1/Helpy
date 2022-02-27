//
//  File.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 14/02/2022.
//

import Foundation
import UIKit
import Firebase

struct Post {
    var id: String?
    var title: String
    var category: String
    var locality: String
    var postalCode: String
    var postDate: Date?
    var proUid: String
    var description: String
    var image: UIImage?
    var imageUrl: String
    var isOnline: Bool
    
    // MARK: Initialize with Raw Data
    init(title: String, category: String, locality: String, postalCode: String, postDate: Date, proUid: String, description: String, image: UIImage?, imageUrl: String, isOnline: Bool) {
        self.title = title
        self.category = category
        self.locality = locality
        self.postalCode = postalCode
        self.postDate = postDate
        self.proUid = proUid
        self.description = description
        self.image = image
        self.imageUrl = imageUrl
        self.isOnline = isOnline
    }
        
    // MARK: Convert Post to AnyObject
    func toDictionnary() -> [String: Any] {
        return [
            "title": title,
            "category": category,
            "locality": locality,
            "postalCode": postalCode,
            "postDate": postDate ?? Date(),
//            "postDate": postDate?.formatted(date: .numeric, time: .shortened) ?? "N/A",
            "proUid": proUid,
            "description": description,
            "imageUrl": imageUrl,
            "isOnline": isOnline,
        ]
    }

        // MARK: Initialize with Firebase DataSnapshot
        init?(snapshot: QueryDocumentSnapshot) {
            guard
                let title = snapshot["title"] as? String,
                let category = snapshot["category"] as? String,
                let locality = snapshot["locality"] as? String,
                let postalCode = snapshot["postalCode"] as? String,
                let postDate = snapshot["postDate"] as? Date,
                let proUid = snapshot["proUid"] as? String,
                let description = snapshot["description"] as? String,
                let imageUrl = snapshot["imageUrl"] as? String,
                let isOnline = snapshot["isOnline"] as? Bool
            else {
                return nil
            }
            self.id = snapshot.documentID
            self.title = title
            self.category = category
            self.locality = locality
            self.postalCode = postalCode
            self.postDate = postDate
            self.proUid = proUid
            self.description = description
            self.imageUrl = imageUrl
            self.isOnline = isOnline
        }
}
