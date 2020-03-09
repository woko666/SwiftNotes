import Foundation
import UIKit
import CleanroomLogger
import RxCocoa
import RxSwift

class NotesDetailViewModel {
    var notesService: NotesService
    
    var note: NoteViewModel?
    
    let disposeBag = DisposeBag()
    
    init(notesService: NotesService) {
        self.notesService = notesService
    }
    
    var isEditing: Bool {
        return note != nil
    }
    
    var text: String {
        return note?.title ?? ""
    }
    
    func createNote(text: String, success: @escaping (NoteViewModel) -> Void, error: @escaping () -> Void) {
        notesService.createNote(title: text).delay(.milliseconds(1000), scheduler: MainScheduler.instance).subscribe(onNext: { note in
            success(NoteViewModel(model: note))
        }, onError: { _ in
            error()
        }).disposed(by: disposeBag)
    }
    
    func editNote(text: String, success: @escaping (NoteViewModel) -> Void, versionError: @escaping (String) -> Void, error: @escaping () -> Void) {
        guard let note = note else {
            error()
            return
        }
        
        notesService.updateNote(id: note.id, title: text).delay(.milliseconds(1000), scheduler: MainScheduler.instance).subscribe(onNext: { note in
            success(NoteViewModel(model: note))
        }, onError: { e in
            if let error = e as? VersioningError, case .invalidCas(let previousValue) = error {
                versionError(previousValue)
            } else {
                error()
            }
        }).disposed(by: disposeBag)
    }
    
    func forceEditNote(text: String, success: @escaping (NoteViewModel) -> Void, error: @escaping () -> Void) {
        guard let note = note else {
            error()
            return
        }
        
        notesService.updateNoteForce(id: note.id, title: text).delay(.milliseconds(1000), scheduler: MainScheduler.instance).subscribe(onNext: { note in
            success(NoteViewModel(model: note))
        }, onError: { _ in
            error()
        }).disposed(by: disposeBag)
    }
    
    func deleteNote(success: @escaping () -> Void, error: @escaping () -> Void) {
        guard let note = note else {
            error()
            return
        }
        
        notesService.deleteNote(id: note.id).delay(.milliseconds(1000), scheduler: MainScheduler.instance).subscribe(onNext: {
            success()
        }, onError: { _ in
            error()
        }).disposed(by: disposeBag)
    }
    
    func replaceNoteTitle(_ text: String) {
        note?.title = text
    }
}
