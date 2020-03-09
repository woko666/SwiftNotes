import Foundation
import Moya
import RxSwift
import RxRelay

class NotesServiceMoya: NotesServiceCaching {
    var notesCacheService: NotesCacheService
    
    init(notesCacheService: NotesCacheService) {
        self.notesCacheService = notesCacheService
        notes.accept(notesCacheService.notes)
    }
    
    var notes = BehaviorRelay<[NoteItem]>(value: [])
       
    var provider = MoyaProvider<NotesProvider>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: [.verbose]))])
    
    func refreshNotes() -> Observable<Void> {
        return provider.rx.request(.getNotes)
            .checkStatusCode()
            .mapJson([NoteMoya].self)
            .map { notes in
                self.updateNoteValues(notes)
                return ()
            }
            .asObservable()
    }
    
    private func getNote(id: Int) -> Observable<NoteItem> {
        return provider.rx.request(.getNote(id: id))
            .checkStatusCode()
            .mapJson(NoteMoya.self)
            .map { $0 as NoteItem }
            .asObservable()
    }
    
    func createNote(title: String) -> Observable<NoteItem> {
        return provider.rx.request(.createNote(title: title))
            .checkStatusCode()
            .mapJson(NoteMoya.self)
            .map { note in
                self.updateNoteValues(self.notes.value + [note])
                return note as NoteItem
            }
            .asObservable()
    }
    
    func updateNoteForce(id: Int, title: String) -> Observable<NoteItem> {
        return provider.rx.request(.updateNote(id: id, title: title))
            .checkStatusCode()
            .mapJson(NoteMoya.self)
            .map { note in
                self.updateNoteValue(id: note.id, title: note.title)
                return note as NoteItem
            }
            .asObservable()
    }
    
    func updateNote(id: Int, title: String) -> Observable<NoteItem> {
        guard let existing = notes.value.first(where: { $0.id == id }) else { return .error(VersioningError.itemNotExists) }
        
        return getNote(id: id).flatMap { note -> Observable<NoteItem> in
            if note.cas != existing.cas {
                self.updateNoteValue(id: note.id, title: note.title)
                throw VersioningError.invalidCas(previousValue: note.title)
            }
            return self.updateNoteForce(id: id, title: title)
        }
    }
    
    func deleteNote(id: Int) -> Observable<Void> {
        return provider.rx.request(.deleteNote(id: id))
            .checkStatusCode()
            .map { _ in
                self.deleteNoteValue(id: id)
                return
            }
            .asObservable()
    }
}
