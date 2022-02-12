//
//  Client.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import Firebase

struct Client {
    let ref: DatabaseReference?
    let key: String
    let lastName: String
    let firstName: String
    let uid: String
    
    // MARK: Initialize with Raw Data
    init(lastName: String, firstName: String, uid: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.lastName = lastName
        self.firstName = firstName
        self.uid = ""
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let lastName = value["lastName"] as? String,
            let firstName = value["firstName"] as? String,
            let uid = value["uid"] as? String
        else {
            return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.lastName = lastName
        self.firstName = firstName
        self.uid = uid
    }
    
    // MARK: Convert Client to AnyObject
    func toAnyObject() -> Any {
        return [
            "lastName": lastName,
            "firstName": firstName,
            "uid": uid
        ]
    }
}
