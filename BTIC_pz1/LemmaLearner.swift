//
//  LemmaLearner.swift
//  BTIC_pz1
//
//  Created by Artur on 12.06.2021.
//

import Foundation

final class LemmaLearner {
    
    // MARK: - Properties
    
    /// Dictionary with word descriptions. A key is the word and a value is an array of word descriptions. One word description consist of lemma, tag, and the word. In most of cases an array has only one value, but there are cases when one word has several lemmas and tags.
    /// The dictionary is used instead of just an array for speed. It's faster to get words decription by key than iterating over an array of word descriptions.
    ///
    /// To fill the dictionary call the `learn(from:)` method.
    private(set) var wordsDescriptionsDict: [String: [WordDescription]] = [:]
    private var fileManager: FileManager = .default
    
    // MARK: - Methods
    
    /// Reads the file with word forms and saves the data to the `wordsDescriptionsDict`.
    func learn(from file: URL) throws {
        let fileContent = try String(contentsOfFile: file.path)
        let wordGroupsTextBlocks = fileContent.components(separatedBy: "\n\n")
        
        print("Found \(wordGroupsTextBlocks.count) word groups")
        print("Started creating word descriptions")
        var iteration = 0
        let wordDescriptions: [WordDescription] = wordGroupsTextBlocks.map { textBlock -> [WordDescription] in
            if textBlock.isEmpty {
                return []
            }
            if iteration.isMultiple(of: 10_000) {
                print("Processed \(Int(Double(iteration) / Double(wordGroupsTextBlocks.count) * 100))%")
            }
            let lines = textBlock.split(separator: "\n").map { String($0) }
            let lemma = String(lines[1].split(separator: "\t")[0]).normalized
            iteration += 1
            
            return lines.compactMap {
                WordDescription(line: $0, lemma: lemma)
            }
        }.flatMap { $0 }
        
        iteration = 0
        print("Started grouping of word descriptions by a word")
        wordDescriptions.forEach { wordDescription in
            let wordDescriptions = self.wordsDescriptionsDict[wordDescription.word]?.appending(wordDescription) ?? [wordDescription]
            self.wordsDescriptionsDict[wordDescription.word] = wordDescriptions
            if iteration.isMultiple(of: 10_000) {
                print("Processed \(Int(Double(iteration) / Double(wordGroupsTextBlocks.count) * 100))%")
            }
            iteration += 1
        }
        print("Finished grouping of word descriptions by a word")
    }
    
    /// Saves the content of `wordsDescriptionsDict` to the file at `url`.
    ///
    /// The method is supposed to be called after the `learn(from:)`.
    func saveLearned(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .prettyPrinted]
        print("Started saving learned data")
        let data = try encoder.encode(wordsDescriptionsDict)
        print("Finished saving learned data")
        try data.write(to: url)
    }
}
