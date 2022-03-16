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
    
    init(sender: String, content: String) {
        self.sender = sender
        self.content = content
    }
    
    // MARK: Convert Message to Dictionnary
    func toDictionnary() -> [String: Any] {
        return [
            "sender": sender,
            "content": content
        ]
    }
    
    // MARK: Initialize with Firebase DataSnapshot
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let sender = snapshot["sender"] as? String,
            let content = snapshot["content"] as? String
        else {
            return nil
        }
        
        self.sender = sender
        self.content = content
    }
}

