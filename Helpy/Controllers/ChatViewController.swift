//
//  ChatViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 06/03/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(let string):
            return "text"
        case .attributedText(let nSAttributedString):
            return "attributedText"
        case .photo(let mediaItem):
            return "photo"
        case .video(let mediaItem):
            return "video"
        case .location(let locationItem):
            return "location"
        case .emoji(let string):
            return "emoji"
        case .audio(let audioItem):
            return "audio"
        case .contact(let contactItem):
            return "contact"
        case .linkPreview(let linkItem):
            return "linkPreview"
        case .custom(let optional):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Sender(senderId: uid, displayName: "Seb Gaillard")
    }
    
    var isNewConversation = true
    var otherUid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello world message")))

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }

}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self sender is nil")
        return Sender(senderId: "", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let selfSender = self.selfSender
        else { return }
        print("Sending: \(text)...")
        
        if isNewConversation {
            // Create convo in database
            let message = Message(sender: selfSender, messageId: UUID().uuidString, sentDate: Date(), kind: .text(text))
            FirebaseRealtimeDatabaseManager.shared.createNewConversation(to: otherUid, firstMessage: message) { success in
                if success {
                    print("message sent")
                } else {
                    print("failed to send")
                }
            }
        } else {
            // append to existing conversation data
        }
    }
}
