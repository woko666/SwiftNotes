import Foundation
import UIKit
import CleanroomLogger

public class NotesCoordinator: Coordinator {
    public weak var parent: Coordinator?
    public var children: [Coordinator] = []
    public let router: Router
    public let storyboards: StoryboardService
    
    public init(parent: Coordinator, router: Router, storyboards: StoryboardService) {
        self.parent = parent
        self.router = router
        self.storyboards = storyboards
    }
    
    public func present(animated: Bool, onDismissed: (() -> Void)?) {
        Log.info?.message("Show a list of notes")
        let vc = storyboards.instantiate(NotesListViewController.self)
        vc.delegate = self
        router.present(vc, animated: animated, onDismissed: onDismissed)
    }
}

// MARK: MainMenuViewControllerDelegate
extension NotesCoordinator: NotesListViewControllerDelegate {
    func editNote(_ note: NoteViewModel, viewController: NotesListViewController) {
        let vc = storyboards.instantiate(NotesDetailViewController.self)
        vc.viewModel.note = note
        vc.delegate = self
        router.present(vc, animated: true)
    }
    
    func newNote(_ viewController: NotesListViewController) {
        let vc = storyboards.instantiate(NotesDetailViewController.self)
        vc.delegate = self
        router.present(vc, animated: true)
    }
}

// MARK: NotesDetailViewControllerDelegate
extension NotesCoordinator: NotesDetailViewControllerDelegate {
    func dismiss(_ viewController: NotesDetailViewController) {
        router.pop(animated: true)
    }
}
