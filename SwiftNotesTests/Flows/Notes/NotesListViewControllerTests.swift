import Foundation
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
@testable import Swift_Notes

class NotesListViewControllerTests: QuickSpec {
    override func spec() {
        describe("NotesListViewController") {
            let resolver = StoryboardServiceTests()
            var vc: NotesListViewController!
            
            beforeEach {
                vc = resolver.instantiate(NotesListViewController.self, initialize: false)
            }
            
            context("with successful data load") {
                beforeEach {
                    let service = resolver.resolve(NotesService.self) as! NotesServiceMock
                    service.success = true
                    vc.initializeViews()
                }
                
                it("should have table loaded") {
                    expect(vc.view.matchSubviews(UILabel.self, equals: { $0.text?.count ?? 0 > 10 }).count).to(beGreaterThan(10))
                    expect(vc.view.getTableNumOfRows()).to(beGreaterThan(10))
                }
                
                it("search should work") {
                    vc.viewModel.input.search.accept("zzzzzzzzzz")
                    expect(vc.view.matchSubviews(UILabel.self, equals: { $0.text?.count ?? 0 > 10 }).count).to(beLessThan(5))
                    expect(vc.view.getTableNumOfRows()).to(equal(0))
                }
            }
            
            context("with loading error") {
                beforeEach {
                    let service = resolver.resolve(NotesService.self) as! NotesServiceMock
                    service.success = false
                    service.clear()
                    vc.initializeViews()
                }
                
                it("should have empty table") {
                    expect(vc.view.matchSubviews(UILabel.self, equals: { $0.text?.count ?? 0 > 10 }).count).to(beLessThan(5))
                    expect(vc.view.getTableNumOfRows()).to(equal(0))
                }
            }
        }
    }
}
