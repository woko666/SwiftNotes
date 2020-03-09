import Foundation
import RxDataSources

struct NoteViewModel: Equatable, IdentifiableType {
    var identity: Int { return id }
    typealias Identity = Int
    
    static func == (lhs: NoteViewModel, rhs: NoteViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    var id: Int
    var title: String
    
    init(model: NoteItem) {
        self.id = model.id
        self.title = model.title
    }
}
