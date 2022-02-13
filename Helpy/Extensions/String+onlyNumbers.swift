//
//  String+onlyNumbers.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import Foundation

extension String {
    var onlyNumbers: String {
        var charset = CharacterSet.decimalDigits
        charset = charset.inverted
        
        return components(separatedBy: charset).joined()
    }
}
