//
//  String+Extensions.swift
//  BTIC_pz1
//
//  Created by Artur on 12.06.2021.
//

import Foundation

extension String {
    var firstLetter: Character {
        self[self.startIndex]
    }
    var secondLetter: Character? {
        let secondCharIndex = self.index(after: self.startIndex)
        return self.endIndex > secondCharIndex ? self[secondCharIndex] : nil
    }
}
