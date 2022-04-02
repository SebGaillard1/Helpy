//
//  HelpyTests.swift
//  HelpyTests
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import XCTest
import Firebase
import CoreLocation
@testable import Helpy

class FirestoreManagerTestCase: XCTestCase {
    var post: Post!
    
    override func setUp() {
        super.setUp()
        
        post = Post(title: "Post Exemple", category: "Exemple", locality: "Lyon", postalCode: "69002", latitude: 43.6216533, longitude: 3.6216533, geohash: "spf8pm14t3", proUid: "UmFHryyZ4qWG2cps41OFWB43NTC3", postedBy: "Seb", description: "Description exemple", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //self.clearFirestore()
    }
    
    
    func testGivenAPostToSaveWhenSavingItToFirestoreThenShouldHaveOnePost() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseDatabaseManager.shared.savePost(post: Post(title: "Post Exemple", category: "Au pair", locality: "Paris", postalCode: "69002", latitude: 48.8786916, longitude: 2.3315296, geohash: "u09wj41g08", proUid: "Uid1", postedBy: "Seb", description: "Description de l’annonce 2 !", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)) { error in
            XCTAssertNil(error)

            FirebaseDatabaseManager.shared.getPostFrom(pro: "Uid1") { posts in
                XCTAssertNotNil(posts)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 3)
    }

    func testGivenAPostWhenGetingRecentPostsThenShouldHaveAPost() {
        let exp = XCTestExpectation(description: "wait")
        
        FirebaseDatabaseManager.shared.savePost(post: Post(title: "Post Exemple", category: "Au pair", locality: "Paris", postalCode: "69002", latitude: 48.8786916, longitude: 2.3315296, geohash: "u09wj41g08", proUid: "UmFHryyZ4qWG2cps41OFWB43NTC3", postedBy: "Seb", description: "Description de l’annonce 2 !", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)) { error in
            XCTAssertNil(error)

            FirebaseDatabaseManager.shared.getRecentPosts { posts in
                XCTAssertNotNil(posts)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 3)
    }
    
    func testGivenAPostSavedWhenDownloadingImageThenSouldHaveAnImage() {
        let exp = XCTestExpectation(description: "wait")
        
        FirebaseDatabaseManager.shared.savePost(post: Post(title: "Post Exemple", category: "Au pair", locality: "Paris", postalCode: "69002", latitude: 48.8786916, longitude: 2.3315296, geohash: "u09wj41g08", proUid: "Uid2", postedBy: "Seb", description: "Description de l’annonce 2 !", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)) { error in
            XCTAssertNil(error)

            
            FirebaseDatabaseManager.shared.getRecentPosts { posts in
                FirebaseDatabaseManager.shared.downloadImage(from: posts[0].imageUrl) { postImage in
                    XCTAssertNotNil(postImage)
                    exp.fulfill()
                }
            }
        }

        wait(for: [exp], timeout: 3)
    }

    func testGivenAPostWithNoImageWhenDownloadingImageThenShouldGetPlaceholderImage() {
        let exp = XCTestExpectation(description: "wait")

        FirebaseDatabaseManager.shared.savePost(post: Post(title: "Post Exemple", category: "Au pair", locality: "Paris", postalCode: "69002", latitude: 48.8786916, longitude: 2.3315296, geohash: "u09wj41g08", proUid: "Uid3", postedBy: "Seb", description: "Description de l’annonce 2 !", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)) { error in
            XCTAssertNil(error)

            FirebaseDatabaseManager.shared.getPostFrom(pro: "Uid3") { posts in
                FirebaseDatabaseManager.shared.downloadImage(from: "") { postImage in
                    XCTAssertNotNil(postImage)
                    exp.fulfill()
                }
            }
        }

        wait(for: [exp], timeout: 3)
    }
    
    func testGivenAPostWhenGettingtPostByLocationThenShouldHaveAPost() {
        let exp = XCTestExpectation(description: "wait")

        FirebaseDatabaseManager.shared.savePost(post: Post(title: "Post Exemple", category: "Au pair", locality: "Paris", postalCode: "69002", latitude: 48.8786916, longitude: 2.3315296, geohash: "u09wj41g08", proUid: "Uid3", postedBy: "Seb", description: "Description de l’annonce 2 !", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)) { error in
            XCTAssertNil(error)

            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(48.8786916), longitude: CLLocationDegrees(2.3315296))
            FirebaseDatabaseManager.shared.getPostByLocation(category: "Au pair", center: center, radiusInMeters: 1000) { posts in
                XCTAssertNotNil(posts)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 3)
    }
    
    func testGivenAPostWhenGettingPostWithNoVlaidCategoryThenShouldNotReturnPost() {
        let exp = XCTestExpectation(description: "wait")

        FirebaseDatabaseManager.shared.savePost(post: Post(title: "Post Exemple", category: "Au pair", locality: "Paris", postalCode: "69002", latitude: 48.8786916, longitude: 2.3315296, geohash: "u09wj41g08", proUid: "Uid3", postedBy: "Seb", description: "Description de l’annonce 2 !", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)) { error in
            XCTAssertNil(error)

            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(48.8786916), longitude: CLLocationDegrees(2.3315296))
            FirebaseDatabaseManager.shared.getPostByLocation(category: "BadCategory", center: center, radiusInMeters: 1000) { posts in
                XCTAssertEqual(posts.count, 0)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 3)
    }
    
    func testGivenAPostWhenGettingAllPostByLocationThenShouldHavePost() {
        let exp = XCTestExpectation(description: "wait")

        FirebaseDatabaseManager.shared.savePost(post: Post(title: "Post Exemple", category: "Au pair", locality: "Paris", postalCode: "69002", latitude: 48.8786916, longitude: 2.3315296, geohash: "u09wj41g08", proUid: "Uid3", postedBy: "Seb", description: "Description de l’annonce 2 !", image: UIImage(named: "garde-enfant"), imageUrl: "", isOnline: false)) { error in
            XCTAssertNil(error)

            let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(48.8786916), longitude: CLLocationDegrees(2.3315296))
            FirebaseDatabaseManager.shared.getPostByLocation(category: "", center: center, radiusInMeters: 1000) { posts in
                XCTAssertNotNil(posts)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 3)
    }
    
    func testGivenAProUserWhenGettinUserNameThenShouldGetProName() {
        let exp = XCTestExpectation(description: "wait")
        FirebaseAuthManager.shared.createUser(userType: .pro, withEmail: "emailpro1@mail.com", password: "password", lastName: "Gaillard", firstName: "SebProTest") { authResult, error in
            XCTAssertNil(error)
            XCTAssertNotNil(authResult)
            FirebaseDatabaseManager.shared.getProName(forUid: authResult?.user.uid ?? "") { name in
                XCTAssertEqual(name, "SebProTest")
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 3)
    }
    
    func testGivenNoProUserConnectedWhenGettingProNameThenShouldHaveNoName() {
        let exp = XCTestExpectation(description: "wait")
        
            FirebaseDatabaseManager.shared.getProName(forUid: "nonexistingpro") { name in
                XCTAssertNil(name)
                exp.fulfill()
            }

        wait(for: [exp], timeout: 3)
    }
}
