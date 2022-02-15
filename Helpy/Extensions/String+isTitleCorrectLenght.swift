//
//  String+lenghtBetween1and100.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import Foundation

extension String {
    var isTitleCorrectLenght: Bool {
        let title = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if title.count > 1 && title.count < 100 {
            return true
        } else {
            return false
        }
    }
}
