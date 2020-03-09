import Foundation
import UIKit
import CleanroomLogger

public class AppCoordinator: Coordinator {
    public weak var parent: Coordinator?
    public var children: [Coordinator] = []
    public let router: Router
    public let storyboards: StoryboardService
    
    public init(router: Router, storyboards: StoryboardService) {
        self.router = router
        self.storyboards = storyboards
    }
    
    public func present(animated: Bool, onDismissed: (() -> Void)?) {
        showMain(animated: animated, onDismissed: onDismissed)
    }
        
    func showMain(animated: Bool, onDismissed: (() -> Void)?) {
        Log.info?.message("Show main flow")
        
        let navigationController = NavigationViewController()
        router.present(navigationController, animated: animated, onDismissed: onDismissed)
        let routerChild = NavigationRouter(navigationController: navigationController)
        let coordinatorChild = NotesCoordinator(parent: self, router: routerChild, storyboards: storyboards)
        presentChild(coordinatorChild, animated: false, onDismissed: nil)
    }
}
