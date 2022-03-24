//
//  Professional.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import Firebase

struct Professional {
    let lastName: String
    let firstName: String
    let email: String
    let uid: String
    
    // MARK: Initialize with Raw Data
    init(lastName: String, firstName: String, email: String, uid: String) {
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.uid = uid
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let lastName = value["lastName"] as? String,
            let firstName = value["firstName"] as? String,
            let email = value["email"] as? String,
            let uid = value["uid"] as? String
        else {
            return nil
        }
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.uid = uid
    }
    
    // MARK: Convert Professional to AnyObject
    func toDictionnary() -> [String: Any] {
        return [
            "lastName": lastName,
            "firstName": firstName,
            "email": email,
            "uid": uid
        ]
    }
}
