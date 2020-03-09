import Foundation
import CryptoSwift

protocol NoteItem {
    var id: Int { get set }
    var title: String { get set }
}

extension NoteItem {
    var cas: String {
        return title.data(using: .utf8)?.sha256().toHexString() ?? ""
    }
}
