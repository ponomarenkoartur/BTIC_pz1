import Foundation

public enum Tag: String, Codable {
    case S
    case A
    case V
    case PR
    case CONJ
    case ADV
    case PNCT
    case NI
}

extension Tag {
    static func fromXML(_ tagValue: String) -> Tag? {
        switch tagValue {
        case let x where x.contains("ADVB"): return Tag(rawValue: "ADV")
        case let x where x.contains("UNKN"): return Tag(rawValue: "NI")
        case let x where x.contains("GRND"): return Tag(rawValue: "V")
        case let x where x.contains("PRCL"): return Tag(rawValue: "ADV")
        case let x where x.contains("PREP"): return Tag(rawValue: "PR")
        case let x where x.contains("ADJS"): return Tag(rawValue: "A")
        case let x where x.contains("PRTS"): return Tag(rawValue: "V")
        case let x where x.contains("INFN"): return Tag(rawValue: "V")
        case let x where x.contains("VERB"): return Tag(rawValue: "V")
        case let x where x.contains("LATN"): return Tag(rawValue: "NI")
        case let x where x.contains("ADJF"): return Tag(rawValue: "A")
        case let x where x.contains("PNCT"): return .PNCT
        case let x where x.contains("PRTF"): return Tag(rawValue: "V")
        case let x where x.contains("NOUN"): return Tag(rawValue: "S")
        case let x where x.contains("INTJ"): return Tag(rawValue: "ADV")
        case let x where x.contains("SYMB"): return Tag(rawValue: "NI")
        case let x where x.contains("PRED"): return Tag(rawValue: "NI")
        case let x where x.contains("COMP"): return Tag(rawValue: "A")
        case let x where x.contains("NUMB"): return Tag(rawValue: "NI")
        case let x where x.contains("CONJ"): return Tag(rawValue: "CONJ")
        case let x where x.contains("ROMN"): return Tag(rawValue: "NI")
        case let x where x.contains("NUMR"): return Tag(rawValue: "NI")
        case let x where x.contains("NPRO"): return Tag(rawValue: "NI")
        default:
            return nil
        }
    }
}
