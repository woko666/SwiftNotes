import UIKit
import UIWindowTransitions

public class AppDelegateRouter: Router {
    public let window: UIWindow
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]

    public init(window: UIWindow) {
        self.window = window
    }

    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        
        if animated, window.rootViewController != nil {
            UIApplication.shared.keyWindow?.setRootViewController(viewController, options: UIWindow.TransitionOptions(direction: .toRight))
        } else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }

    public func dismiss(animated: Bool) {
        if let first = window.rootViewController {
            performOnDismissed(for: first)
        }
    }
    
    public func revert(animated: Bool) {
        // nop
    }
    
    public func pop(animated: Bool) {
        // nop
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else {
            return
        }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
    
    /*public func dismiss(animated: Bool) {
        // don't do anything
    }*/
}
