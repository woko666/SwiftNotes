import Foundation
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest
import RxNimble
import Swinject

class UITestBase: QuickSpec {
    var app: XCUIApplication!
    
    func initApp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launchArguments.append("testingResetAll")
        continueAfterFailure = false
        app.launch()
    }
    
    @discardableResult func waitForElementToAppear(name: String, tries: Int = 5, require: Bool = true, file: String = #file, line: UInt = #line) -> XCUIElement? {
        for _ in 0..<tries {
            let predicate = NSPredicate(format: "identifier CONTAINS '\(name)'")
            let elements = app.otherElements.matching(predicate)
            if elements.allElementsBoundByIndex.count > 0 {
                sleep(1)
                let element = elements.allElementsBoundByIndex[0]
                return element
            }
            sleep(1)
        }
        
        let message = "Failed to find \(name) after \(tries) seconds."
        recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
        if require {
            expect(message).to(equal(""))
        }
        return nil
    }
    
    func waitForNavBarButtonToAppear(tries: Int = 5, require: Bool = true, file: String = #file, line: UInt = #line) -> XCUIElement? {
        for _ in 0..<tries {
            let elements = app.navigationBars.buttons
            if elements.allElementsBoundByIndex.count > 0 {
                let element = elements.allElementsBoundByIndex[0]
                return element
            }
            sleep(1)
        }
        
        let message = "Failed to find nav bar button after \(tries) seconds."
        recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
        if require {
            expect(message).to(equal(""))
        }
        return nil
    }
    
    func typeToElement(_ element: XCUIElement, text: String, clear: Bool = false) {
        /*UIPasteboard.general.string = text
         element.doubleTap()
         app.menuItems.element(boundBy: 0).tap()*/
        tapElementAndWaitForKeyboardToAppear(element)
        if clear {
            element.doubleTap()
            app.keys["delete"].tap()
        }
        element.typeText(text)
    }
    
    func tapElementAndWaitForKeyboardToAppear(_ element: XCUIElement) {
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            element.tap()
            if keyboard.exists {
                break;
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
    }
    
    func getMemoryUsed() -> Float {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let kerr = withUnsafeMutablePointer(to: &info) { infoPtr in
            return infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { (machPtr: UnsafeMutablePointer<integer_t>) in
                return task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO),  machPtr, &count
                )
            }
        }
        guard kerr == KERN_SUCCESS else {
            return 0
        }
        return Float(info.resident_size) / (1024 * 1024)
    }
}
