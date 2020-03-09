import Foundation
@testable import Swift_Notes
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
import Swinject
import SpecLeaks

class ViewControllerLeakTests: QuickSpec {
    override func spec() {
        let resolver = StoryboardServiceTests()
        
        describe("NotesListViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return resolver.instantiateVC(NotesListViewController.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }
        
        describe("NotesDetailViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return resolver.instantiateVC(NotesDetailViewController.self)
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }
    }
}
