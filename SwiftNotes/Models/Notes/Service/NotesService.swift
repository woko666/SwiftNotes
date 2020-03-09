import Foundation
import RxSwift
import RxRelay

protocol NotesService: class {
    var notes: BehaviorRelay<[NoteItem]> { get }
    func refreshNotes() -> Observable<Void>
    func createNote(title: String) -> Observable<NoteItem>
    func updateNote(id: Int, title: String) -> Observable<NoteItem>
    func updateNoteForce(id: Int, title: String) -> Observable<NoteItem>
    func deleteNote(id: Int) -> Observable<Void>
}
