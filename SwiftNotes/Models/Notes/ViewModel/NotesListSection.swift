import Foundation
import RxDataSources

struct NotesListSection {
    var header: String = ""
    var items: [NoteViewModel] = []
}

extension NotesListSection: AnimatableSectionModelType {
    typealias Item = NoteViewModel
    typealias Identity = String
    var identity: Identity { return header }
    
    init(original: NotesListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
