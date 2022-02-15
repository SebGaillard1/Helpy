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
    let ref: DatabaseReference?
    let key: String
    var title: String
    var category: String
    var locality: String
    var postalCode: String
    var postDate: Date
    var proUid: String
    var description: String
    var imageUrl: String
    var isOnline: Bool
    
    // MARK: Initialize with Raw Data
    init(title: String, category: String, locality: String, postalCode: String, postDate: Date, proUid: String, description: String, imageUrl: String, isOnline: Bool, key: String = "") {
        self.ref = nil
        self.key = key
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
        
    // MARK: Convert Post to AnyObject
    func toAnyObject() -> Any {
        return [
            "title": title,
            "category": category,
            "locality": locality,
            "postalCode": postalCode,
            "postDate": postDate.formatted(date: .numeric, time: .shortened),
            "proUid": proUid,
            "description": description,
            "imageUrl": imageUrl,
            "isOnline": isOnline,
        ]
    }
    
    //    // MARK: Initialize with Firebase DataSnapshot
    //    init?(snapshot: DataSnapshot) {
    //        guard
    //            let value = snapshot.value as? [String: AnyObject],
    //            let title = value["lastName"] as? String,
    //            let category = value["firstName"] as? String,
    //            let locality = value["email"] as? String,
    //            let postalCode = value["job"] as? String,
    //            let postDate = value["uid"] as? String,
    //            let proUid = value["firstName"] as? String,
    //            let description = value["email"] as? String,
    //            let image = value["job"] as? String,
    //            let isOnline = value["uid"] as? String
    //        else {
    //            return nil
    //        }
    //        self.ref = snapshot.ref
    //        self.key = snapshot.key
    //        self.title = title
    //        self.category = category
    //        self.locality = locality
    //        self.postalCode = postalCode
    //        self.postDate = postDate
    //        self.proUid = proUid
    //        self.description = description
    //        self.image = image
    //        self.isOnline = isOnline
    //    }
}
