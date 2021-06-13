import Foundation

public enum LemmatizerError: Error {
    case invalidXML
}

public enum FileReadError: Error {
    case fileNotFound(filePath: String)
}
