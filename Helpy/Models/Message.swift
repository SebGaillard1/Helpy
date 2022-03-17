//
//  Message.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/03/2022.
//

import Foundation
import FirebaseFirestore

struct Message {
    let senderUid: String
    let senderName: String
    let content: String
    let receiverUid: String
    let receiverName: String
    
    init(senderUid: String, senderName: String, content: String, receiverUid: String, receiverName: String) {
        self.senderUid = senderUid
        self.senderName = senderName
        self.content = content
        self.receiverUid = receiverUid
        self.receiverName = receiverName
    }
    
    // MARK: Convert Message to Dictionnary
    func toDictionnary() -> [String: Any] {
        return [
            "senderUid": senderUid,
            "senderName": senderName,
            "content": content,
            "receiverUid": receiverUid,
            "receiverName": receiverName
        ]
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let senderUid = snapshot["senderUid"] as? String,
            let senderName = snapshot["senderName"] as? String,
            let content = snapshot["content"] as? String,
            let receiverUid = snapshot["receiverUid"] as? String,
            let receiverName = snapshot["receiverName"] as? String
        else {
            return nil
        }
        
        self.senderUid = senderUid
        self.senderName = senderName
        self.content = content
        self.receiverUid = receiverUid
        self.receiverName = receiverName
    }
}

