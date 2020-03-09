import Foundation
import UIKit
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

public class StoryboardServiceImpl: StoryboardService {
    var container: Container!
    
    init() {
        container = Container()
        
        // services
        container.autoregister(NotesService.self, initializer: NotesServiceMoya.init).inObjectScope(ObjectScope.container)
        container.autoregister(NotesCacheService.self, initializer: NotesCacheServiceRealm.init).inObjectScope(ObjectScope.container)
        
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
    
    public func instantiate<ViewController>(_ serviceType: ViewController.Type) -> ViewController where ViewController: StoryboardInstantiable {
        return container.resolveViewController(serviceType)
    }
    
    public func instantiateVC(_ serviceType: StoryboardInstantiable.Type) -> UIViewController {
        return container.resolveViewControllerType(serviceType)
    }
    
    public func resolve<T: Any>(_ classType: T.Type) -> T? {
        return container.resolve(classType)
    }
}
