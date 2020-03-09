import Foundation
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
@testable import Swift_Notes

class NotesListViewModelTests: QuickSpec {
    override func spec() {
        describe("NotesListViewModel") {
            
            var vm: NotesListViewModel!
            var service: NotesServiceMock!
            var recorder: ObservableRecorder<[NotesListSection]>!
            
            beforeEach {
                service = NotesServiceMock(notesCacheService: NotesCacheServiceMock())
                vm = NotesListViewModel(notesService: service)
                recorder = ObservableRecorder(valueSubject: vm.output.notes)
            }
            
            context("with valid data") {
                beforeEach {
                    service.success = true
                    vm.loadValues()
                }
                
                it("should load valid data") {
                    expect(recorder.contains({ $0.count > 1 })) == true
                }
                
                it("search should work") {
                    vm.input.search.accept("zzzzzzzzzz")
                    expect(try! recorder.last().first?.items.count) == 0
                }
                
                it("delete should work") {
                    var isError = false
                    vm.deleteNote(id: 1, success: {
                    }, error: {
                        isError = true
                    })
                    expect(isError) == false
                }
            }
            
            context("with network error") {
                beforeEach {
                    service.success = false
                    vm.loadValues()
                }
                
                it("should return empty") {
                    expect(recorder.contains({ $0.count == 1 && $0[0].items.count == 0 })) == true
                }
            }
        }
    }
}
