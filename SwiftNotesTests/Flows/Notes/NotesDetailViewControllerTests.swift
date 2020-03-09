import Foundation
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
import PopupDialog
@testable import Swift_Notes

class NotesDetailViewControllerTests: QuickSpec {
    override func spec() {
        describe("NotesDetailViewController") {
            let resolver = StoryboardServiceTests()
            let note = NoteMoya(id: 1, title: "Notetext")
            var vc: NotesDetailViewController!
            var delegate: NotesDetailViewControllerDelegateSpy!
            
            beforeEach {
                vc = resolver.instantiate(NotesDetailViewController.self, initialize: false)
                delegate = NotesDetailViewControllerDelegateSpy()
                vc.delegate = delegate
            }
            
            context("when editing an existing note") {
                beforeEach {
                    vc.viewModel.note = NoteViewModel(model: note)
                    vc.initializeViews()
                }
                
                it("should have non-empty textarea") {
                    expect(vc.textArea.text).to(equal(note.title))
                }
                
                it("delete should work") {
                    vc.deleteNote()
                    expect(delegate.hasDismissed).toEventually(beTrue(), timeout: 10)
                }
                
                it("save should work") {
                    vc.onSave()
                    expect(vc.view.getSubviews(PopupDialogContainerView.self).count).toEventually(equal(0), timeout: 10)
                }
                
                it("save should fail") {
                    vc.initializeViews(inWindow: true)
                    let service = resolver.resolve(NotesService.self) as! NotesServiceMock
                    service.success = false
                    service.clear()
                    vc.onSave()
                    expect(self.windowViews.map { $0.getSubviews(PopupDialogContainerView.self).count }.reduce(0, +)).toEventually(equal(1), timeout: 10)
                }
            }
        }
    }
}

class NotesDetailViewControllerDelegateSpy: NotesDetailViewControllerDelegate {
    var hasDismissed = false
    func dismiss(_ viewController: NotesDetailViewController) {
        hasDismissed = true
    }
}
