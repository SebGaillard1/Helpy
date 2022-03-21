//
//  HelpyTests.swift
//  HelpyTests
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import XCTest
import Firebase

@testable import Helpy
import CoreLocation

class HelpyTests: XCTestCase {
    var post: Post!
    
    override func setUp() {
        post = Post(title: "Post Exemple", category: "Exemple", locality: "Lyon", postalCode: "69002", latitude: CLLocationDegrees(43.6216533), longitude: CLLocationDegrees(3.6216533), geohash: "spf8pm14t3", proUid: "UmFHryyZ4qWG2cps41OFWB43NTC3", postedBy: "Seb", description: "Description exemple", image: UIImage(named: "garde-enfant"), imageUrl: "urlexemple.com", isOnline: true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.clearFirestore()
    }
    
//    func testGivenNoRecentPostsWhenFetchingRecentPostsThenShouldReturnNothing() {
//        let exp = self.expectation(description: "Waiting for async operation")
//
//        FirebaseDatabaseManager.shared.getRecentPosts { posts in
//            print(posts.count)
//            XCTAssertEqual(posts.count, 0)
//            exp.fulfill()
//        }
//
//        self.waitForExpectations(timeout: 5, handler: nil)
//    }
    
    func testGivenAPostToSaveWhenSavingItToFirestoreThenShouldHaveOnePost() {
        let exp = self.expectation(description: "Waiting for async operation")
        FirebaseDatabaseManager.shared.savePost(post: post) { error in
            XCTAssertNil(error)
            
            FirebaseDatabaseManager.shared.getPostFrom(pro: "UmFHryyZ4qWG2cps41OFWB43NTC3") { posts in
                XCTAssertNotNil(posts)
                XCTAssertEqual(posts.count, 1)
                print(posts.count)
                XCTAssertEqual(posts.first?.title, "Post Exemple")
                
                exp.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }

//    func testGetRecentPosts() {
//        let exp = self.expectation(description: "Waiting for async operation")
//        FirebaseDatabaseManager.shared.getRecentPosts { posts in
//            print(posts.count)
//            exp.fulfill()
//        }
//
//        self.waitForExpectations(timeout: 5, handler: nil)
//    }
    
    func clearFirestore() {
      let semaphore = DispatchSemaphore(value: 0)
      let projectId = FirebaseApp.app()!.options.projectID!
      let url = URL(string: "http://localhost:8080/emulator/v1/projects/\(projectId)/databases/(default)/documents")!
      var request = URLRequest(url: url)
      request.httpMethod = "DELETE"
      let task = URLSession.shared.dataTask(with: request) { _,_,_ in
        print("Firestore cleared")
        semaphore.signal()
      }
      task.resume()
      semaphore.wait()
    }
}
