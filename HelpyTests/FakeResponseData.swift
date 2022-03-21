//
//  FakeResponseData.swift
//  HelpyTests
//
//  Created by Sebastien Gaillard on 21/03/2022.
//

import Foundation

class FakeResponseData {
    //MARK: - Data
    static var location: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Location", withExtension: ".json")!
        return try! Data(contentsOf: url)
    }
    

    static var imageData: Data? {
        let bundle = Bundle.main
        let url = bundle.url(forResource: "image", withExtension: ".png")!
        return try! Data(contentsOf: url)
    }
    
    static let incorrectData = "erreur".data(using: .utf8)
    
    //MARK: - Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    //MARK: - Error
    class FakeError: Error {}
    static let error = FakeError()
}
