//
//  main.swift
//  BTIC_pz1
//
//  Created by Artur on 12.06.2021.
//

import Foundation
import AppKit

// MARK: - Path

let resourcesFolder = URL(fileURLWithPath: "/Users/mac/Documents/Files/University/10 semester/ВТІС/BTIC_pz1/BTIC_pz1/Resources")

/// The file contains dict with word forms
let fileForLearningWords = resourcesFolder.appendingPathComponent("dict.opcorpora.txt")
/// The file contains word forms usage examples. The file is needed to learn word frequency.
let fileForLearningPriority = resourcesFolder.appendingPathComponent("annot.opcorpora.xml")
/// The file with an input.
let inputFile = resourcesFolder.appendingPathComponent("input.txt")

/// The file contains JSON. It is a dictionary where a key is a word and the value is an array of objects with a lemma, a tag, and the word again.
let learnedWordsFile = resourcesFolder.appendingPathComponent("learned.txt")
/// The file contains JSON. It is a dictionary where a key is a word's lemma and the value is and the lemma frequency.
let learnedPrioritizationFile = resourcesFolder.appendingPathComponent("learnedPrioritization.txt")
/// The file for the output.
let outputFile = resourcesFolder.appendingPathComponent("output.txt")

// MARK: - Lemmatization

let lemmatizer = Lemmatizer(prioritizationFile: learnedPrioritizationFile)
let lemmaLearner = LemmaLearner()
let lemmaPrioritizationLearner = LemmaPrioritizationLearner()

do {
    /// First, you need to learn words' lemmas, tags and words' frequency. For this uncomment next 4 lines.
    /// After, the structured data will be saved to the `learnedWordsFile` and `learnedPrioritizationFile` perspectively.
    /// And then it's not necessary to call these methods again once we have done.
//    try lemmaPrioritizationLearner.learn(from: learnPriorityFile)
//    try lemmaLearner.learn(from: learnFile)
//    try lemmaPrioritizationLearner.saveLearned(to: learnedPrioritizationFile)
//    try lemmaLearner.saveLearned(to: learnedFile)

    /// Then you need to read learned words' lemmas at the `learnedWordsFile` by the `lemmatizer`
    try lemmatizer.readWordDescriptions(from: learnedWordsFile)
    
    /// This is where we process `inputFile` and add lemmas and tags to the words. The output is written to the `outputFile`
    try lemmatizer.lemmatize(inputFile: inputFile, outputFile: outputFile)
} catch LemmatizerError.invalidXML {
    print("Failed learning with file: \(fileForLearningWords)")
} catch FileReadError.fileNotFound(let filePath) {
    print("File at: \(filePath) not found")
} catch {
    print("Unknown error: \(error.localizedDescription)")
}
