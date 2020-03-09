import Foundation
import Moya
import RxSwift
import RxRelay

protocol NotesServiceCaching: NotesService {
    var notesCacheService: NotesCacheService { get }
}

extension NotesServiceCaching {
    func updateNoteValues(_ notes: [NoteItem]) {
        self.notes.accept(notes)
        notesCacheService.notes = notes
    }
    
    func updateNoteValue(id: Int, title: String) {
        let notes = self.notes.value.map { note -> NoteItem in
            if note.id == id {
                return NoteMoya(id: id, title: title)
            } else {
                return note
            }
        }
        updateNoteValues(notes)
    }
    
    func deleteNoteValue(id: Int) {
        updateNoteValues(self.notes.value.filter { $0.id != id })
    }
}
