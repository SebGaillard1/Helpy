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
    
    func testCreateClient() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "email@exemple.fr", password: password, lastName: "", firstName: "") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3)
    }
    
    func testCreateClientWhenAlreadyExisting() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "email3@exemple.fr", password: password, lastName: "", firstName: "") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "email3@exemple.fr", password: self.password, lastName: "", firstName: "") { authResult, error in
                XCTAssertNil(authResult)
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 3)
    }

    func testSignInClient() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .client, withEmail: "email2@exemple.fr", password: password, lastName: "", firstName: "") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            do {
                try Auth.auth().signOut()
            } catch let error {
                print("Auth sign out failed: \(error)")
            }
            FirebaseAuthManager.shared.signInUser(userType: .client, withEmail: "email2@exemple.fr", password: self.password) { error in
                XCTAssertNil(error)
                XCTAssertNotNil(Auth.auth().currentUser?.uid)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 3)
    }

    func testSignInNonExistingClient() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.signInUser(userType: .client, withEmail: "nonertretil@exemple.fr", password: self.password) { error in
                XCTAssertNotNil(error)
                exp.fulfill()
            }

        wait(for: [exp], timeout: 3)
    }

    func testCreatePro() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .pro, withEmail: "emailpro@exemple.fr", password: password, lastName: "", firstName: "") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 3)
    }

    func testCreateProWhenAlreadyExisting() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .pro, withEmail: "emailpro3@exemple.fr", password: password, lastName: "", firstName: "") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            FirebaseAuthManager.shared.createUser(userType: .pro, withEmail: "emailpro3@exemple.fr", password: self.password, lastName: "", firstName: "") { authResult, error in
                XCTAssertNil(authResult)
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 3)
    }

    func testSignInPro() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .pro, withEmail: "emailpro2@exemple.fr", password: password, lastName: "", firstName: "") { authResult, error in
            XCTAssertNotNil(authResult)
            XCTAssertNil(error)
            FirebaseAuthManager.shared.signInUser(userType: .pro, withEmail: "emailpro2@exemple.fr", password: self.password) { error in
                XCTAssertNil(error)
                XCTAssertNotNil(Auth.auth().currentUser?.uid)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 3)
    }

}
