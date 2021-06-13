import Foundation

/// The class reads file with words, processes the words and adds lemmas and tag to the words.
/// To process words the class read the file with structured words description and words frequency.
final class Lemmatizer {
        
    // MARK: - Properties
    
    private let fileManager = FileManager.default
    /// Dictionary with word descriptions. A key is the word and a value is an array of word descriptions. One word description consist of lemma, tag, and the word. In most of cases an array has only one value, but there are cases when one word has several lemmas and tags.
    /// The dictionary is used instead of just an array for speed. It's faster to get words decription by key than iterating over an array of word descriptions.
    private var wordDescriptionsDict: [String: [WordDescription]] = [:]
    /// Prioritizer that read data from `prioritizationFile` and give the most frequent lemma for the word.
    private lazy var lemmaPrioritizer = LemmaPrioritizer(prioritizationFile: prioritizationFile)
    /// The URL of the file with structured words and frequencies.
    private let prioritizationFile: URL
    
    // MARK: - Initialization
    
    init(prioritizationFile: URL) {
        self.prioritizationFile = prioritizationFile
    }
    
    // MARK: - Methods
    
    /// Processes `inputFile` and adds lemmas and tags to the words.
    /// The output is written to the `outputFile`
    func lemmatize(inputFile: URL, outputFile: URL) throws {
        print("Started reading file: \(inputFile.relativePath)")
        let inputFileContent = try String(contentsOfFile: inputFile.path, encoding: .utf8)
        print("Finished reading file: \(inputFile.relativePath)")
        try "".write(to: outputFile, atomically: true, encoding: .utf8)
        
        print("Started spliting file by linebreak")
        let sentences = inputFileContent.split(separator: "\n")
        print("Finished spliting file by linebreak. Sentence count: \(sentences.count)")
        
        print("Started lemmatizing sentences")
        let lemmatizedSentencesData: [Data] = try sentences.enumerated().compactMap { offset, sentence in
            let lemmatizedSentence = try lemmatizeSentence(String(sentence))
            print("Lemmatized \(offset) sentences")
            return (lemmatizedSentence + "\n").data(using: .utf8)
        }
        print("Finished lemmatizing sentences")
        
        let handle = try FileHandle(forWritingTo: outputFile)
        for lemmatizedSentenceData in lemmatizedSentencesData {
            try handle.seekToEnd()
            handle.write(lemmatizedSentenceData)
        }
    }

    /// Reads words descriptions from the `file` where data is already structured.
    /// Structure is a dictionary with words descriptions. A key is the word and a value is an array of word descriptions. One word description consist of lemma, tag, and the word. In most of cases an array has only one value, but there are cases when one word has several lemmas and tags.
    /// The dictionary is used instead of just an array for speed. It's faster to get words decription by key than iterating over an array of word descriptions.
    func readWordDescriptions(from file: URL) throws {
        let decoder = JSONDecoder()
        print("Started reading content of \(file)")
        let data = try Data(contentsOf: file, options: [])
        print("Finished reading content of \(file)")
        print("Started parsing tokens")
        self.wordDescriptionsDict = try decoder.decode([String: [WordDescription]].self, from: data)
        print("Finished parsing tokens")
    }
    
    // MARK: - Private Methods
    
    /// Returns `sentence` with added lemmas and tags to the each word.
    ///
    /// Ignores punctuation signs: ",", ".", "?", "!", ";"
    /// Normalize words of the sentence, i.e. replaces 'ё' with 'е', and lowercases the words.
    /// Finds word description for the each word. If it finds more the one description, then it takes the desciption the highest frequency.
    /// If no description is found then the word itself is used as a lemma and 'ADV' tag is used.
    private func lemmatizeSentence(_ sentence: String) throws -> String {
        try sentence
            .filter {
                ![",", ".", "?", "!", ";"].contains($0)
            }
            .split(separator: " ")
            .map { word in
                let word = String(word)
                let normalizedWord = word.normalized
                let wordDescriptions = wordDescriptionsDict[normalizedWord] ?? []
                var wordDescription: WordDescription?
                if wordDescriptions.count == 1 {
                    wordDescription = wordDescriptions[0]
                } else if wordDescriptions.count > 1,
                          let mostPrioritableWordDescription = try lemmaPrioritizer.getMostPrioritableWordDescription(wordDescriptions) {
                    wordDescription = mostPrioritableWordDescription
                }
                if let token = wordDescription {
                    let tagString = Tag.fromXML(token.tag)?.rawValue ?? Tag.ADV.rawValue
                    return "\(word){\(token.lemma)=\(tagString)}"
                } else {
                    return "\(word){\(normalizedWord)=\(Tag.ADV.rawValue)}"
                }
            }
            .joined(separator: " ")
    }
}

extension String {
    var normalized: String {
        self
            .lowercased()
            .replacingOccurrences(of: "ё", with: "е")
    }
}
