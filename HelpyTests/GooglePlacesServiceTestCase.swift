//
//  GooglePlacesServiceTestCase.swift
//  HelpyTests
//
//  Created by Sebastien Gaillard on 21/03/2022.
//

import XCTest
@testable import Helpy

class GooglePlacesServiceTestCase: XCTestCase {
    private var googlePlacesService: GooglePlacesService!

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        googlePlacesService = GooglePlacesService(session: session)
    }

    override func tearDown() {
        super.tearDown()
        
        googlePlacesService = nil
    }

    func testGivenGoodCoordinatesForLyonWhenFetchingCityAndPostalCodeThenShouldReturnLyonInfos() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.location
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesService.getPostalCodeAndLocality(fromLatitude: "45.764043", fromLongitude: "4.835659") { success, locality, postalCode in
            XCTAssertTrue(success)
            XCTAssertEqual(locality, "Lyon")
            XCTAssertEqual(postalCode, "69002")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenErrorAndNoDataWhenFetchingCityAndPostalCodeThenShouldFail() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = nil
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesService.getPostalCodeAndLocality(fromLatitude: "45.764043", fromLongitude: "4.835659") { success, locality, postalCode in
            XCTAssertFalse(success)
            XCTAssertEqual(locality, "")
            XCTAssertEqual(postalCode, "")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGivenGoodDataBadResponseNoErrorWhenFetchingCityAndPostalCodeThenShouldFail() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.location
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesService.getPostalCodeAndLocality(fromLatitude: "45.764043", fromLongitude: "4.835659") { success, locality, postalCode in
            XCTAssertFalse(success)
            XCTAssertEqual(locality, "")
            XCTAssertEqual(postalCode, "")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }

    func testGivenIncorrectDataGoodResponseNoErrorWhenFetchingCityAndPostalCodeThenShouldFail() {
        // Given
        MockURLProtocol.loadingHandler = { request in
            let data: Data? = FakeResponseData.incorrectData
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesService.getPostalCodeAndLocality(fromLatitude: "45.764043", fromLongitude: "4.835659") { success, locality, postalCode in
            XCTAssertFalse(success)
            XCTAssertEqual(locality, "")
            XCTAssertEqual(postalCode, "")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
}
