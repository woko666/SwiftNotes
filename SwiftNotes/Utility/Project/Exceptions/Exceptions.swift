import Foundation

enum JsonError: Error {
    case parseError(endpoint: String?, data: String, error: String)
    
    static func formatValueHumanReadable(_ value: Any) -> String {
        var pieces: [String] = []
        
        if let custom = value as? CustomDebugStringConvertible {
            pieces.append(custom.debugDescription)
        } else if let custom = value as? CustomStringConvertible {
            pieces.append(custom.description)
        } else {
            pieces.append(String(describing: value))
        }
        
        return pieces.joined()
    }
}

enum NetworkError: Error {
    case statusCodeError(code: Int)
}

enum VersioningError: Error {
    case itemNotExists
    case invalidCas(previousValue: String)
}

enum RuntimeError: Error {
    case message(text: String)
}
