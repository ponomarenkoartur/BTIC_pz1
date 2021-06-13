//
//  LemmaPrioritizationLearner.swift
//  BTIC_pz1
//
//  Created by Artur on 13.06.2021.
//

import Foundation

/// The class count frequency of lemmas
final class LemmaPrioritizationLearner: NSObject {

    private enum Constants {
        static let lemmaKey = "l"
    }

    // MARK: - Properties

    private(set) var lemmaPriority: [String: Int] = [:]

    // MARK: - Methods

    /// Processes xml file.
    /// The file consist of words and corresponding lemmas (actually it contains more details,  be we don't care about them)
    /// The method count number of lemmas and write it to the `lemmaPriority`.
    func learn(from file: URL) throws {
        let parser = XMLParser(contentsOf: file)!
        parser.delegate = self
        parser.parse()
    }

    /// Saves `lemmaPriority` to the file at `url`.
    func saveLearned(to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .prettyPrinted]
        let data = try encoder.encode(lemmaPriority)
        try data.write(to: url)
    }
}

extension LemmaPrioritizationLearner: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if parser.lineNumber.isMultiple(of: 1000) {
            print("Line number \(parser.lineNumber)")
        }

        if elementName == Constants.lemmaKey,
           let lemma = attributeDict["t"] {
            let count = lemmaPriority[lemma] ?? 0
            lemmaPriority[lemma] = count + 1
        }
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        print("Started parsing xml")
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("Ended parsing xml")
    }
}


