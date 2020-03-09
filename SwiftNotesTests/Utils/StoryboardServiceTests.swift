import Foundation
import UIKit
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration
@testable import Swift_Notes

// swiftlint:disable type_body_length
public class StoryboardServiceTests: StoryboardService {
   
    var container: Container!
    
    init() {
        container = Container()
        
        // services
        container.autoregister(NotesService.self, initializer: NotesServiceMock.init).inObjectScope(ObjectScope.container)
        container.autoregister(NotesCacheService.self, initializer: NotesCacheServiceMock.init).inObjectScope(ObjectScope.container)
        
        // VCs
        container.storyboardInitCompleted(NotesListViewController.self) { r, c in
            c.viewModel = r.resolve(NotesListViewModel.self)
        }
        container.storyboardInitCompleted(NotesDetailViewController.self) { r, c in
            c.viewModel = r.resolve(NotesDetailViewModel.self)
        }
        
        // VMs
        container.autoregister(NotesListViewModel.self, initializer: NotesListViewModel.init)
        container.autoregister(NotesDetailViewModel.self, initializer: NotesDetailViewModel.init)
    }
    
    public func instantiate<ViewController>(_ serviceType: ViewController.Type, initialize: Bool = true) -> ViewController where ViewController: StoryboardInstantiable {
        let vc = container.resolveViewController(serviceType)
        if initialize, let vc = vc as? UIViewController {
            vc.beginAppearanceTransition(true, animated: false)
            vc.endAppearanceTransition()
        }
        return vc
    }
    
    public func instantiateVC(_ serviceType: StoryboardInstantiable.Type, initialize: Bool = true) -> UIViewController {
        let vc = container.resolveViewControllerType(serviceType)
        if initialize {
            vc.beginAppearanceTransition(true, animated: false)
            vc.endAppearanceTransition()
        }
        return vc
    }
    
    public func resolveVC<T: UIViewController>(_ classType: T.Type, initialize: Bool = true) -> T {
        let vc = container.resolve(classType)!
        if initialize {
            vc.initializeViews()
        }
        return vc
    }
    
    public func resolve<T: Any>(_ classType: T.Type) -> T? {
        return container.resolve(classType)
    }
    
    public func instantiate<ViewController>(_ serviceType: ViewController.Type) -> ViewController where ViewController : StoryboardInstantiable {
        return instantiate(serviceType, initialize: true)
    }
    
    public func instantiateVC(_ serviceType: StoryboardInstantiable.Type) -> UIViewController {
        return instantiateVC(serviceType, initialize: true)
    }
}
