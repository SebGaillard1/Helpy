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
    
    func sendMessage(message: String, receiverUid: String, receiverName: String, completion: @escaping (_ error: String?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion("Vous n'êtes pas authentifié !")
            return
        }
        let message = Message(sender: currentUid, content: message, receiverUid: receiverUid, receiverName: receiverName)
        
        let ref = db.collection("chats").document(currentUid).collection("receiversUid").document(receiverUid).collection("messages").addDocument(data: message.toDictionnary()) { error in
            guard error == nil else {
                completion(error?.localizedDescription ?? "Impossible d'envoyer votre message")
                return
            }
            completion(nil)
        }
        
        ref.setData(["timestamp": FieldValue.serverTimestamp()], merge: true)
        setLastMessage(message: message)
    }
    
    private func setLastMessage(message: Message) {
        db.collection("chats").document(message.sender).collection("lastsMessages").whereField("receiverUid", isEqualTo: message.receiverUid).getDocuments { snapshot, error in
            guard let snapshot = snapshot, !snapshot.documents.isEmpty, error == nil else {
                self.db.collection("chats").document(message.sender).collection("lastsMessages").addDocument(data: message.toDictionnary())
                return
            }
            
            let ref = snapshot.documents[0].reference
            ref.setData(message.toDictionnary())
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
        print(currentUid)
        
        db.collection("chats").document(currentUid).collection("lastsMessages").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion("Impossible de récupérer les conversations !", [])
                return
            }
            print(snapshot.isEmpty)
            var conversations = [Conversation]()
            for doc in snapshot.documents {
                print(doc.data())
                if let receiverName = doc.data()["receiverName"] as? String,
                   let receiverUid = doc.data()["receiverUid"] as? String,
                   let message = doc.data()["content"] as? String {
                    conversations.append(Conversation(receiverUid: receiverUid, receiverName: receiverName, lastMessage: message))
                }
            }
            
            completion(nil, conversations)
        }
    }
}
