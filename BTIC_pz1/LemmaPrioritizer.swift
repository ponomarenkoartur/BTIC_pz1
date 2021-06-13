//
//  LemmaPrioritizer.swift
//  BTIC_pz1
//
//  Created by Artur on 13.06.2021.
//

import Foundation

/// Class the prioriatize words by frequency of theis lemmas
final class LemmaPrioritizer {
    
    // MARK: - Properties
    
    /// The file that contains structured data of the words with the corresponding frequency value.
    private let prioritizationFile: URL
    /// Dictionary of word frequency. The key is a word lemma and the value is the number of found words with such a lemma.
    private var prioritizationDict: [String: Int] = [:]
    
    // MARK: - Initialization
    
    init(prioritizationFile: URL) {
        self.prioritizationFile = prioritizationFile
    }
    
    // MARK: - Methods
    
    /// Returns the most prioritable word description among the `wordDescriptions`.
    ///
    /// The most prioritable description is a description that has the biggest number in the `prioritizationDict` by the word lemma.
    func getMostPrioritableWordDescription(_ wordDescriptions: [WordDescription]) throws -> WordDescription? {
        if prioritizationDict.isEmpty {
            try parsePrioritization()
        }
        switch wordDescriptions.count {
        case 0:
            return nil
        case 1:
            return wordDescriptions[0]
        default:
            break
        }
        let wordDescriptionIndex = wordDescriptions.enumerated().filter { _, element in
            prioritizationDict[element.lemma] != nil
        }.max {
            prioritizationDict[$0.element.lemma]! < prioritizationDict[$1.element.lemma]!
        }?.offset
        if let wordDescriptionIndex = wordDescriptionIndex {
            return wordDescriptions[wordDescriptionIndex]
        } else {
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    /// Parse the structured data from the JSON file and saves to the `prioritizationDict`.
    private func parsePrioritization() throws {
        let decoder = JSONDecoder()
        print("Started reading content of \(prioritizationFile)")
        let data = try Data(contentsOf: prioritizationFile, options: [])
        print("Finished reading content of \(prioritizationFile)")
        print("Started parsing prioritization")
        self.prioritizationDict = try decoder.decode([String: Int].self, from: data)
        print("Finished parsing prioritization")
    }
}
