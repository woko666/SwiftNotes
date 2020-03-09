import Foundation
import RxSwift
@testable import Swift_Notes

import Foundation
import Moya
import RxSwift
import RxRelay

class NotesServiceMock: NotesServiceCaching {
    var success: Bool = true
    func clear() {
        updateNoteValues([])
    }
    
    var notesCacheService: NotesCacheService
    init(notesCacheService: NotesCacheService) {
        self.notesCacheService = notesCacheService
        notes.accept(notesCacheService.notes)
    }
    
    var notes = BehaviorRelay<[NoteItem]>(value: [])
    
    private var notesRaw: [NoteItem] {
        let data = TestAssets.getData("notes", ext: "txt")
        return try! JSONDecoder().decode([NoteMoya].self, from: data)
    }
    
    func refreshNotes() -> Observable<Void> {
        return Observable.create { observer in
            if self.success {
                self.updateNoteValues(self.notesRaw)
                observer.on(.next(()))
                observer.on(.completed)
            } else {
                observer.onError(TestError.runtimeError)
            }
            return Disposables.create()
        }
    }
    
    private func getNote(id: Int) -> Observable<NoteItem> {
        return Observable.create { observer in
            if self.success, let note = self.notes.value.first(where: { $0.id == id }) {
                observer.on(.next(note))
                observer.on(.completed)
            } else {
                observer.onError(TestError.runtimeError)
            }
            return Disposables.create()
        }
    }
    
    func createNote(title: String) -> Observable<NoteItem> {
        return Observable.create { observer in
            if self.success {
                let note = NoteMoya(id: 666, title: title)
                self.updateNoteValues(self.notes.value + [note])
                observer.on(.next(note))
                observer.on(.completed)
            } else {
                observer.onError(TestError.runtimeError)
            }
            return Disposables.create()
        }
    }
    
    func updateNoteForce(id: Int, title: String) -> Observable<NoteItem> {
        return Observable.create { observer in
            if self.success {
                self.updateNoteValue(id: id, title: title)
                observer.on(.next(NoteMoya(id: id, title: title)))
                observer.on(.completed)
            } else {
                observer.onError(TestError.runtimeError)
            }
            return Disposables.create()
        }
    }
    
    func updateNote(id: Int, title: String) -> Observable<NoteItem> {
        return updateNoteForce(id: id, title: title)
    }
    
    func deleteNote(id: Int) -> Observable<Void> {
        return Observable.create { observer in
            if self.success {
                self.deleteNoteValue(id: id)
                observer.on(.next(()))
                observer.on(.completed)
            } else {
                observer.onError(TestError.runtimeError)
            }
            return Disposables.create()
        }
    }
}
