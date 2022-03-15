//
//  File.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 14/02/2022.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

struct Post {
    var id: String?
    var title: String
    var category: String
    var locality: String
    var postalCode: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var geohash: String
    var postDate: String
    var proUid: String
    var postedBy: String
    var description: String
    var image: UIImage?
    var imageUrl: String
    var isOnline: Bool
    
    // MARK: Initialize with Raw Data
    init(title: String, category: String, locality: String, postalCode: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, geohash: String, proUid: String, postedBy: String, description: String, image: UIImage?, imageUrl: String, isOnline: Bool) {
        self.title = title
        self.category = category
        self.locality = locality
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
        self.geohash = geohash
        self.postDate = ""
        self.proUid = proUid
        self.postedBy = postedBy
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
            "latitude": Double(latitude),
            "longitude": Double(longitude),
            "geohash": geohash,
            "proUid": proUid,
            "postedBy": postedBy,
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
                let latitude = snapshot["latitude"] as? Double,
                let longitude = snapshot["longitude"] as? Double,
                let geohash = snapshot["geohash"] as? String,
                let postDate = snapshot["postDate"] as? Timestamp,
                let proUid = snapshot["proUid"] as? String,
                let postedBy = snapshot["postedBy"] as? String,
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
            self.latitude = latitude
            self.longitude = longitude
            self.geohash = geohash
            self.postDate = postDate.dateValue().formatted(date: .numeric, time: .shortened)
            self.proUid = proUid
            self.postedBy = postedBy
            self.description = description
            self.imageUrl = imageUrl
            self.isOnline = isOnline
        }
    
    init?(dictionnary: [String: Any]) {
        guard
            let title = dictionnary["title"] as? String,
            let category = dictionnary["category"] as? String,
            let locality = dictionnary["locality"] as? String,
            let postalCode = dictionnary["postalCode"] as? String,
            let latitude = dictionnary["latitude"] as? Double,
            let longitude = dictionnary["longitude"] as? Double,
            let geohash = dictionnary["geohash"] as? String,
            let postDate = dictionnary["postDate"] as? Timestamp,
            let proUid = dictionnary["proUid"] as? String,
            let postedBy = dictionnary["postedBy"] as? String,
            let description = dictionnary["description"] as? String,
            let imageUrl = dictionnary["imageUrl"] as? String,
            let isOnline = dictionnary["isOnline"] as? Bool
        else {
            return nil
        }
        
        self.title = title
        self.category = category
        self.locality = locality
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
        self.geohash = geohash
        self.postDate = postDate.dateValue().formatted(date: .numeric, time: .shortened)
        self.proUid = proUid
        self.postedBy = postedBy
        self.description = description
        self.imageUrl = imageUrl
        self.isOnline = isOnline
    }
}
