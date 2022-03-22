//
//  FirestoreChatTestCase.swift
//  HelpyTests
//
//  Created by Sebastien Gaillard on 21/03/2022.
//

import XCTest
import Firebase
@testable import Helpy

class FirestoreChatTestCase: XCTestCase {
    let message = Message(senderUid: "senderUid", senderName: "senderName", content: "messageContent", receiverUid: "receiverUid", receiverName: "receiverName")
    
    func testGivenNoUserConnectedWhenSendingMessageThenShouldFail() {
        let exp = self.expectation(description: "Waiting for async operation")
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Auth sign out failed: \(error)")
        }
        FirebaseFirestoreChatManager.shared.sendMessage(message: "Exemple", senderName: "name", receiverUid: "exemple", receiverName: "namereceiver") { error in
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testSendMessageTest() {
        let exp = self.expectation(description: "Waiting for async operation")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "emailchat@exemple.fr", password: "password", lastName: "Seb", firstName: "G") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            FirebaseFirestoreChatManager.shared.sendMessage(message: "Exemple", senderName: "name", receiverUid: "exemple", receiverName: "namereceiver") { error in
                XCTAssertNil(error)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGetAllMessages() {
        let exp = self.expectation(description: "Waiting for async operation")
        FirebaseFirestoreChatManager.shared.getAllConversationsWithLastMessage { error, conversations in
            XCTAssertNil(error)
            XCTAssertEqual(conversations.count, 1)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }

    func testTest(){
        let exp = self.expectation(description: "Waiting for async operation")
        FirebaseFirestoreChatManager.shared.getConversationMessages(with: "exemple") { error, messages in
            XCTAssertNil(error)
            XCTAssertEqual(messages.count, 1)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
}

