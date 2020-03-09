import UIKit

public class ModalViewControllerRouter: NSObject {
    
    public unowned let parentViewController: UIViewController
    
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
    }
}

// MARK: Router
extension ModalViewControllerRouter: Router {
    
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[parentViewController] = onDismissed
        parentViewController.present(viewController, animated: animated, completion: nil)
    }
    
    public func dismiss(animated: Bool) {
        parentViewController.dismiss(animated: animated, completion: nil)
        performOnDismissed(for: parentViewController)
    }
    
    public func revert(animated: Bool) {
        parentViewController.dismiss(animated: animated, completion: nil)
    }
    
    public func pop(animated: Bool) {
        // nop
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}
