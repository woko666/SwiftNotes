import Foundation
import Moya

enum NotesProvider: TargetType {
    case getNotes
    case getNote(id: Int)
    case createNote(title: String)
    case updateNote(id: Int, title: String)
    case deleteNote(id: Int)
    
    var baseURL: URL {
        return URL(string: Config.backendBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .getNotes:
            return "list.php"
        case .createNote:
            return "create.php"
        case .getNote:
            return "get.php"
        case .updateNote:
            return "update.php"
        case .deleteNote:
            return "delete.php"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getNotes:
            return .requestPlain
        case .createNote(let title):
            return .requestParameters(parameters: [
                "title": title
            ], encoding: URLEncoding.default)
        case .getNote(let id):
            return .requestParameters(parameters: [
                "id": String(id)
            ], encoding: URLEncoding.default)
        case .updateNote(let id, let title):
            return .requestParameters(parameters: [
                "id": String(id),
                "title": title
            ], encoding: URLEncoding.default)
        case .deleteNote(let id):
            return .requestParameters(parameters: [
                "id": String(id)
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
    // MARK: Mock api @ http://private-9aad-note10.apiary-mock.com/
    /*var baseURL: URL {
        return URL(string: "http://private-9aad-note10.apiary-mock.com/")!
    }
    
    var path: String {
        switch self {
        case .getNotes,
             .createNote:
            return "notes"
        case .getNote(let id),
             .updateNote(let id, _),
             .deleteNote(let id):
            return "notes/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNotes,
             .getNote:
            return .get
        case .createNote:
            return .post
        case .updateNote:
            return .put
        case .deleteNote:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .createNote(let title),
             .updateNote(_, let title):
            return .requestParameters(parameters: ["title": title], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createNote,
             .updateNote:
            return ["Content-Type": "application/json"]
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return Data()
    }*/
}
