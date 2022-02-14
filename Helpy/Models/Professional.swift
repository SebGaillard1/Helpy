//
//  Professional.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import Firebase

struct Professional {
    let ref: DatabaseReference?
    let key: String
    let lastName: String
    let firstName: String
    let email: String
    let job: String
    let uid: String
    
    // MARK: Initialize with Raw Data
    init(lastName: String, firstName: String, email: String, job: String, uid: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.job = job
        self.uid = uid
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let lastName = value["lastName"] as? String,
            let firstName = value["firstName"] as? String,
            let email = value["email"] as? String,
            let job = value["job"] as? String,
            let uid = value["uid"] as? String
        else {
            return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.job = job
        self.uid = uid
    }
    
    // MARK: Convert Professional to AnyObject
    func toAnyObject() -> Any {
        return [
            "lastName": lastName,
            "firstName": firstName,
            "email": email,
            "job": job,
            "uid": uid
        ]
    }
}
