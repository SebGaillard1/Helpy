//
//  GeocodingData.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 04/03/2022.
//

import Foundation
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
// MARK: - Welcome
struct Welcome: Codable {
    let plusCode: PlusCode
    let results: [Result]
    let status: String

    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: - Result
struct Result: Codable {
    let addressComponents: [AddressComponent]
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case types
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}
