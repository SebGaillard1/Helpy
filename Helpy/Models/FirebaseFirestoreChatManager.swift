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
    
    func sendMessage(message: String, to otherUid: String, completion: @escaping (_ error: String?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion("Vous n'êtes pas authentifié !")
            return
        }
        let message = Message(sender: currentUid, content: message)
        
        let ref = db.collection("chats").document(currentUid).collection("receiversUid").document(otherUid).collection("messages").addDocument(data: message.toDictionnary()) { error in
            guard error == nil else {
                completion(error?.localizedDescription ?? "Impossible d'envoyer votre message")
                return
            }
            completion(nil)
        }
        
        ref.setData(["timestamp": FieldValue.serverTimestamp()], merge: true)
        setLastMessage(message: message, with: otherUid)
    }
    
    private func setLastMessage(message: Message, with otherUid: String) {
        var dictionnary = message.toDictionnary()
        dictionnary["receiverUid"] = otherUid
        db.collection("chats").document(message.sender).collection("lastsMessages").addDocument(data: dictionnary)
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
    
//    func getAllConversationsWithLastMessage(forUid uid: String, completion: @escaping (_ error: String?, _ conversations: Conversation?) -> Void) {
//        guard let currentUid = Auth.auth().currentUser?.uid else {
//            completion("Vous n'êtes pas authentifié !", nil)
//            return
//        }
//
//        db.collection("chat").document(currentUid).addSnapshotListener { snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                completion("Impossible de récupérer les conversations !", nil)
//                return
//            }
//
//            for doc in snapshot
//        }
//    }
}
