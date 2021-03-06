//
//  FirebaseFirestoreChatManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/03/2022.
//

import Foundation
import Firebase

final class FirebaseFirestoreChatManager {
    //MARK: - Singleton
    static var shared = FirebaseFirestoreChatManager()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    func sendMessage(message: String, senderName: String, receiverUid: String, receiverName: String, completion: @escaping (_ error: String?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion("Vous n'êtes pas authentifié !")
            return
        }
        let message = Message(senderUid: currentUid, senderName: senderName, content: message, receiverUid: receiverUid, receiverName: receiverName)
    
        let ref = db.collection("chats").document(currentUid).collection("receiversUid").document(receiverUid).collection("messages").addDocument(data: message.toDictionnary()) { error in
            guard error == nil else {
                completion(error?.localizedDescription ?? "Impossible d'envoyer votre message")
                return
            }
        }
    
        ref.setData(["timestamp": FieldValue.serverTimestamp()], merge: true) { _ in
            self.saveLastMessage(message: message) { success in
                success ? completion(nil) : completion("Impossible d'envoyer le message")
            }
        }
    }
    
    private func saveLastMessage(message: Message, completion: @escaping (_ success: Bool) -> Void) {
        db.collection("chats").document(message.senderUid).collection("lastsMessages").whereField("receiverUid", in: [message.receiverUid, message.senderUid]).getDocuments { snapshot, error in
            guard let snapshot = snapshot, !snapshot.documents.isEmpty, error == nil else {
                self.db.collection("chats").document(message.senderUid).collection("lastsMessages").addDocument(data: message.toDictionnary()) { _ in
                    completion(true)
                }
                return
            }
            
            let ref = snapshot.documents[0].reference
            ref.setData(message.toDictionnary()) { _ in
                self.saveMessageInReceiverCollection(message: message) { success in
                    completion(true)
                }
            }
        }
    }
    
    private func saveMessageInReceiverCollection(message: Message, completion: @escaping (_ success: Bool) -> Void) {
        let ref = db.collection("chats").document(message.receiverUid).collection("receiversUid").document(message.senderUid).collection("messages").addDocument(data: message.toDictionnary())
        ref.setData(["timestamp": FieldValue.serverTimestamp()], merge: true) { _ in
            self.setLastMessageInReceiverCollection(message: message) { success in
                completion(true)
            }
        }
    }
    
    private func setLastMessageInReceiverCollection(message: Message, completion: @escaping (_ success: Bool) -> Void) {
        db.collection("chats").document(message.receiverUid).collection("lastsMessages").whereField("receiverUid", in: [message.receiverUid, message.senderUid]).getDocuments { snapshot, error in
            guard let snapshot = snapshot, !snapshot.documents.isEmpty, error == nil else {
                self.db.collection("chats").document(message.receiverUid).collection("lastsMessages").addDocument(data: message.toDictionnary()) { _ in
                    completion(true)
                }
                return
            }
            
            let ref = snapshot.documents[0].reference
            ref.setData(message.toDictionnary()) { _ in
                completion(true)
            }
        }

    }
    
    func getConversationMessages(with otherUid: String, completion: @escaping (_ error: String?, _ messages: [Message]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion("Vous n'êtes pas authentifié !", [])
            return
        }
    
        db.collection("chats").document(currentUid).collection("receiversUid").document(otherUid).collection("messages").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, !snapshot.isEmpty, error == nil else {
                completion("Impossible de récupérer les messages !", [])
                return
            }
            var messages = [Message]()
    
            snapshot.documents.forEach { doc in
                if let message = Message(snapshot: doc) {
                    messages.append(message)
                }
            }
    
            completion(nil, messages.reversed())
        }
    }
    
    func getAllConversationsWithLastMessage(completion: @escaping (_ error: String?, _ conversations: [Conversation]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion("Vous n'êtes pas authentifié !", [])
            return
        }
    
        db.collection("chats").document(currentUid).collection("lastsMessages").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion("Impossible de récupérer les conversations !", [])
                return
            }
            var conversations = [Conversation]()
            for doc in snapshot.documents {
                if let receiverName = doc.data()["receiverName"] as? String,
                   let receiverUid = doc.data()["receiverUid"] as? String,
                   let senderUid = doc.data()["senderUid"] as? String,
                   let senderName = doc.data()["senderName"] as? String,
                   let message = doc.data()["content"] as? String {
                    if currentUid == receiverUid {
                        conversations.append(Conversation(otherUid: senderUid, otherName: senderName, lastMessage: message, myUid: receiverUid, myName: receiverName))
                    } else {
                        conversations.append(Conversation(otherUid: receiverUid, otherName: receiverName, lastMessage: message, myUid: senderUid, myName: senderName))
                    }
                }
            }
    
            completion(nil, conversations)
        }
    }
   
}


