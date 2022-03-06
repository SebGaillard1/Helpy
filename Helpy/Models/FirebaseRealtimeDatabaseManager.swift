//
//  FirebaseRealtimeDatabaseManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 06/03/2022.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

final class FirebaseRealtimeDatabaseManager {
    static let shared = FirebaseRealtimeDatabaseManager()
    
    private let db = Database.database(url: Constants.FirebaseHelper.realtimeDbUrl).reference()
    
    public func createNewConversation(to otherUid: String, firstMessage: Message, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        db.child(currentUid).setValue(currentUid) { error, ref in
            guard error == nil else {
                completion(false)
                return
            }
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            let messageDate = firstMessage.sentDate
            let dateString = messageDate.formatted(date: .numeric, time: .shortened)
            var message = ""
            
            switch firstMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let newConversationData: [String: Any] = [
                "id": "conversation_\(conversationId)",
                "other_user_uid": otherUid,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            ref.setValue(newConversationData) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                let messageDict: [String: Any] = [
                    "id": conversationId,
                    "type": firstMessage.kind.messageKindString,
                    "content": message,
                    "date": dateString,
                    "sender_uid": currentUid,
                    "is_read": false
                ]
                
                let value: [String: Any] = [
                    "messages": [
                        messageDict
                    ]
                ]
                
                self.db.child(conversationId).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    public func getAllConversations(forUid uid: String, completion: @escaping (_ result: String) -> Void) {
        
    }
    
    public func getAllMessagesForConversation(withId id: String, completion: @escaping (_ result: String) -> Void) {
        
    }
    
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (_ success: Bool) -> Void) {
        
    }
}

