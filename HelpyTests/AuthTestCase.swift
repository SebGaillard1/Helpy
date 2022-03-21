//
//  AuthTestCase.swift
//  HelpyTests
//
//  Created by Sebastien Gaillard on 21/03/2022.
//

import XCTest
import Firebase
@testable import Helpy

class AuthTestCase: XCTestCase {
    let password = "passwordExemple"
    
    override func tearDown() {
        super.tearDown()
        
        Auth.auth().currentUser?.delete()
    }
    
    func testCreateUser() {
        let exp = self.expectation(description: "Waiting for async operation")
        FirebaseAuthManager.shared.createUser(withEmail: "email@exemple.fr", password: password) { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3)
    }
    
    func testCreateUserWhenAlreadyExisting() {
        let exp = self.expectation(description: "Waiting for async operation")
        FirebaseAuthManager.shared.createUser(withEmail: "email3@exemple.fr", password: password) { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            FirebaseAuthManager.shared.createUser(withEmail: "email3@exemple.fr", password: self.password) { authResult, error in
                XCTAssertNil(authResult)
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 3)
    }
    
    func testSignInUser() {
        let exp = self.expectation(description: "Waiting for async operation")
        FirebaseAuthManager.shared.createUser(withEmail: "email2@exemple.fr", password: password) { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            FirebaseAuthManager.shared.signInUser(withEmail: "email2@exemple.fr", password: self.password) { error in
                XCTAssertNil(error)
                XCTAssertNotNil(Auth.auth().currentUser?.uid)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 3)
    }
    
    func testSignInNonExistingUser() {
        let exp = self.expectation(description: "Waiting for async operation")
            FirebaseAuthManager.shared.signInUser(withEmail: "nonexistingemail@exemple.fr", password: self.password) { error in
                XCTAssertNotNil(error)
                XCTAssertNil(Auth.auth().currentUser?.uid)
                exp.fulfill()
            }
        
        wait(for: [exp], timeout: 3)
    }

}
