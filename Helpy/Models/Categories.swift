//
//  Jobs.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import Foundation

struct Categories {
    static var categoriesArray: [String] {
        if let categoriesURL = Bundle.main.url(forResource: "categories", withExtension: "txt") {
            if let categories = try? String(contentsOf: categoriesURL) {
                return categories.components(separatedBy: "\n")
            }
        }
        return []
    }
}

