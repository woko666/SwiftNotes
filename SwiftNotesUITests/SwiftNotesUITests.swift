import Foundation
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
import RxNimble
import Swinject

class SwiftNotesUITests: UITestBase {
    let maxMemoryDiff: Float = 10
    
    override func spec() {
        beforeSuite {
            self.initApp()
        }
        describe("UI Test") {
            
            context("check memory") {
                
                it("doesn't leak") {
                    let initialMemory = self.getMemoryUsed()
                    
                    for _ in 0..<10 {
                        self.app.tables.cells.element(boundBy: 1).tap()
                        self.app.navigationBars.buttons.element(boundBy: 0).tap()
                    }
                    let memory = self.getMemoryUsed()
                    let diff = memory - initialMemory
                    sleep(5) // give the simulator a chance to GC
                    expect(diff).to(beLessThan(self.maxMemoryDiff))
                }
            }
        }
    }
}
