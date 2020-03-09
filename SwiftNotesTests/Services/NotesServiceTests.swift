import Foundation
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
import RxNimble
import Swinject
@testable import Swift_Notes

class NotesServiceTests: QuickSpec {
    override func spec() {
        describe("NotesServiceMoya") {
            var service: NotesServiceMoya!
            
            beforeEach {
                service = NotesServiceMoya(notesCacheService: NotesCacheServiceRealm())
            }
            
            context("refresh notes") {
                it("should succeed") {
                    let result = service.refreshNotes().toBlocking().materialize()
                    expect(result).to(self.beCompleted())
                    expect(service.notes.value.count) > 0
                }
            }
            
            context("update a note") {
                it("should succeed") {
                    let result = service.updateNote(id: 1, title: "If any cop asks you where you were, just say you were visiting Kansas.").toBlocking().materialize()
                    expect(result).to(self.containsInCompleted({$0.id == 1}))
                }
            }
            
            context("create and delete a note") {
                it("should succeed") {
                    let result = service.createNote(title: "Test note").toBlocking().materialize()
                    expect(result).to(self.beCompleted())
                    if case .completed(let values) = result, let note = values.first {
                        let deleteResult = service.deleteNote(id: note.id).toBlocking().materialize()
                        expect(deleteResult).to(self.beCompleted())
                    }
                }
            }
        }
    }
}
