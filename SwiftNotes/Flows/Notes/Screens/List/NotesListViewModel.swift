import Foundation
import UIKit
import CleanroomLogger
import RxCocoa
import RxSwift

class NotesListViewModel: ViewModelType {
    // MARK: Services
    var notesService: NotesService
    
    // MARK: Input
    struct Input {
        let search: BehaviorRelay<String>
        let refreshNotes: AnyObserver<Void>
    }
    let input: Input
    private let search = BehaviorRelay<String>(value: "")
    private let refreshNotes = PublishSubject<Void>()
    
    // MARK: Output
    struct Output {
        let isLoading: Observable<Bool>
        let notes: Observable<[NotesListSection]>
    }
    let output: Output
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let notes: Observable<[NotesListSection]>
    
    let disposeBag = DisposeBag()
    
    static let showSectionsFromItems = 10
    
    init(notesService: NotesService) {
        self.notesService = notesService
        
        // updates when notes or search text has changed
        self.notes = Observable.combineLatest(search, notesService.notes)
            .map({ params -> [NoteItem] in
                let (search, notes) = params
                
                if search.isEmpty {
                    return notes
                } else {
                    return notes.filter({ $0.title.localizedCaseInsensitiveContains(search) })
                }
            })
            .map({ $0.sorted(by: { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }) })
            .map({ notes -> [NotesListSection] in
                var sections: [NotesListSection] = []

                // sort into sections if above limit
                guard notes.count >= NotesListViewModel.showSectionsFromItems else {
                    return [NotesListSection(header: "", items: notes.map { NoteViewModel(model: $0) })]
                }
                
                notes.forEach({ note in
                    let noteModel = NoteViewModel(model: note)
                    
                    let header: String = "\(note.title.first ?? "#")".uppercased()
                    if let index = sections.firstIndex(where: { $0.header == header }) {
                        sections[index].items.append(noteModel)
                    } else {
                        let section = NotesListSection(header: header, items: [noteModel])
                        sections.append(section)
                    }
                })

                return sections
            })
        
        self.input = Input(search: search, refreshNotes: refreshNotes.asObserver())
        self.output = Output(isLoading: isLoading.asObservable(), notes: notes)
        
        // On signal refresh notes, but only if not already refreshing
        refreshNotes.retry()
            .flatMap { [weak self] () -> Observable<Bool> in
                if self?.isLoading.value ?? true {
                    return Observable.just(false)
                }
                 
                self?.isLoading.accept(true)
                return notesService.refreshNotes().delay(.milliseconds(2000), scheduler: MainScheduler.instance).map { true }.catchErrorJustReturn(true)
            }
            .subscribe(onNext: { [weak self] processed in
                if processed { // processed is true if `notesService.refreshNotes()` was called, regardless of the result
                    self?.isLoading.accept(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func loadValues() {
        refreshNotes.onNext(())
    }
    
    func deleteNote(id: Int, success: @escaping () -> Void, error: @escaping () -> Void) {
        notesService.deleteNote(id: id).delay(.milliseconds(1000), scheduler: MainScheduler.instance).subscribe(onNext: {
            success()
        }, onError: { _ in
            error()
        }).disposed(by: disposeBag)
    }
}
