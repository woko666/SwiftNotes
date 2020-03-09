import Foundation
import UIKit

extension UIViewController {
    func initializeViews(inWindow: Bool = false) {
        if inWindow {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController = self
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
}
