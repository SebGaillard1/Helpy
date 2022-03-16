//
//  Message.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/03/2022.
//

import Foundation
import FirebaseFirestore

struct Message {
    let sender: String
    let content: String
    let receiverUid: String
    let receiverName: String
    
    init(sender: String, content: String, receiverUid: String, receiverName: String) {
        self.sender = sender
        self.content = content
        self.receiverUid = receiverUid
        self.receiverName = receiverName
    }
    
    // MARK: Convert Message to Dictionnary
    func toDictionnary() -> [String: Any] {
        return [
            "sender": sender,
            "content": content,
            "receiverUid": receiverUid,
            "receiverName": receiverName
        ]
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let sender = snapshot["sender"] as? String,
            let content = snapshot["content"] as? String,
            let receiverUid = snapshot["receiverUid"] as? String,
            let receiverName = snapshot["receiverName"] as? String
        else {
            return nil
        }
        
        self.sender = sender
        self.content = content
        self.receiverUid = receiverUid
        self.receiverName = receiverName
    }
}

