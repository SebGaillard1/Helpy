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
        
        let exp = XCTestExpectation(description: "wait")
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
    
    func testGivenUserIsConnectedWhenSendingMessageThenShouldNotHaveError() {
        let exp = XCTestExpectation(description: "wait")
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
    
    func testGivenUserIsConnectedWhenGettingAllConversationsThenShouldHaveOneConversation() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "emailchat5@mail.com", password: "password", lastName: "seb", firstName: "seb") { authResult, error in
            FirebaseFirestoreChatManager.shared.sendMessage(message: "Test", senderName: "Seb", receiverUid: "receiver", receiverName: "receiverName") { error in
                XCTAssertNil(error)
                FirebaseFirestoreChatManager.shared.getAllConversationsWithLastMessage { error, conversations in
                    XCTAssertNil(error)
                    XCTAssertEqual(conversations.count, 1)
                    exp.fulfill()
                }
            }
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGivenUserConnectedWithMultipleMessagesSentWhenGettingConversationThenShouldHaveOnlyOne() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "emailchat6@mail.com", password: "password", lastName: "seb", firstName: "seb") { authResult, error in
            FirebaseFirestoreChatManager.shared.sendMessage(message: "Test", senderName: "Seb", receiverUid: "receiver", receiverName: "receiverName") { error in
                XCTAssertNil(error)
                FirebaseFirestoreChatManager.shared.sendMessage(message: "Test2", senderName: "Seb", receiverUid: "receiver", receiverName: "receiverName") { error in
                    XCTAssertNil(error)
                    FirebaseFirestoreChatManager.shared.getAllConversationsWithLastMessage { error, conversations in
                        XCTAssertNil(error)
                        XCTAssertEqual(conversations.count, 1)
                        exp.fulfill()
                    }
                }
            }
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGivenUserConnectedWhenGettingAllMessagesThenShouldHaveOneMessage() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "emailchat7@mail.com", password: "password", lastName: "seb", firstName: "seb") { authResult, error in
            FirebaseFirestoreChatManager.shared.sendMessage(message: "Test", senderName: "Seb", receiverUid: "receiverForConv", receiverName: "receiverName") { error in
                XCTAssertNil(error)
                FirebaseFirestoreChatManager.shared.getConversationMessages(with: "receiverForConv") { error, messages in
                    XCTAssertNil(error)
                    XCTAssertEqual(messages.count, 1)
                    exp.fulfill()
                }
            }
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGivenUserConnectedWhenSendingMultipleMessagesThenShouldNotHaveError() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "emailchat10@exemple.fr", password: "password", lastName: "Sebi", firstName: "Gail") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            FirebaseFirestoreChatManager.shared.sendMessage(message: "Exemple", senderName: "name", receiverUid: "exemplenew", receiverName: "namereceiverww") { error in
                XCTAssertNil(error)
                FirebaseFirestoreChatManager.shared.sendMessage(message: "Exemple", senderName: "name", receiverUid: "exemplenew", receiverName: "namereceiverww") { error in
                    XCTAssertNil(error)
                    exp.fulfill()
                }
            }
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGivenNoUserConnectedWhenGettingMessageThenShouldReturnAnErrorAndNoMessage() {
        
        let exp = XCTestExpectation(description: "wait")
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Auth sign out failed: \(error)")
        }
        
        FirebaseFirestoreChatManager.shared.getConversationMessages(with: "testLoggedOut") { error, messages in
            XCTAssertNotNil(error)
            XCTAssertTrue(messages.isEmpty)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGivenNoUserConnectedWhenGettingConversationsThenShouldReturnAnErrorAndNoConversation() {
        let exp = XCTestExpectation(description: "wait")
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Auth sign out failed: \(error)")
        }
        
        FirebaseFirestoreChatManager.shared.getAllConversationsWithLastMessage { error, conversations in
            XCTAssertNotNil(error)
            XCTAssertTrue(conversations.isEmpty)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testGivenConnectedUserIsReceiverWhenGettingConversationThenShouldHaveOneMessageWithoutError() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "emailchat8@mail.com", password: "password", lastName: "seb", firstName: "seb") { authResult, error in
            FirebaseFirestoreChatManager.shared.sendMessage(message: "Test", senderName: "Seb", receiverUid: authResult?.user.uid ?? "", receiverName: "receiverName") { error in
                XCTAssertNil(error)
                FirebaseFirestoreChatManager.shared.getAllConversationsWithLastMessage { error, conversations in
                    XCTAssertNil(error)
                    XCTAssertEqual(conversations.count, 1)
                    exp.fulfill()
                }
            }
        }
        
        wait(for: [exp], timeout: 5)
    }
}

