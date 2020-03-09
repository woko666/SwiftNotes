import UIKit

public class ContainerViewRouter: NSObject {
    
    private let parentController: UIViewController
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    public init(parentController: UIViewController) {
        self.parentController = parentController
        super.init()
    }
}

// MARK: Router
extension ContainerViewRouter: Router {
    
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        parentController.add(viewController)
    }
    
    public func dismiss(animated: Bool) {
        while let child = parentController.children.last {
            child.remove()
            performOnDismissed(for: child)
        }
    }
    
    public func revert(animated: Bool) {
        while let child = parentController.children.last {
            child.remove()
        }
    }
    
    public func pop(animated: Bool) {
        if let last = parentController.children.last {
            last.remove()
            performOnDismissed(for: last)
        }
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController]
            else {
                return
        }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

// MARK: UIViewController extensions
extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
