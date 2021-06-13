//
//  WordDescription.swift
//  BTIC_pz1
//
//  Created by Artur on 12.06.2021.
//

import Foundation

/// Description of the word.
/// It consist of the word itself, the lemma, and the tag.
struct WordDescription: Codable {
    let word: String
    let lemma: String
    let tag: String
}

extension WordDescription {
    /// Initialize a `WordDescription` from the line of file with word-forms.
    init?(line: String, lemma: String) {
        if Int(line) != nil {
            return nil
        }
        let lineParts = line
            .split(separator: "\t")
            .map { String($0) }
        let word = lineParts[0].normalized
        let tag = lineParts[1].split(separator: ",").map { String($0) }[0]
        self.init(word: word, lemma: lemma, tag: tag)
    }
}
