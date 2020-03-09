import Foundation
import UIKit
import Swinject
import SwinjectStoryboard

extension Container {
    // swiftlint:disable force_cast
    /**
    Retrieves UIViewController of the specified type. The UIViewController must conform to StoryboardInstantiable
    - Parameter serviceType: UIViewController type
    - Returns: UIViewController of specified type
    */
    func resolveViewController<ViewController: StoryboardInstantiable>(_ serviceType: ViewController.Type) -> ViewController {
        let storyboard = SwinjectStoryboard.create(name: serviceType.storyboardFileName, bundle: nil, container: self)
        return storyboard.instantiateViewController(withIdentifier: serviceType.storyboardIdentifier) as! ViewController
    }
    
    func resolveViewControllerType(_ serviceType: StoryboardInstantiable.Type) -> UIViewController {
        let storyboard = SwinjectStoryboard.create(name: serviceType.storyboardFileName, bundle: nil, container: self)
        return storyboard.instantiateViewController(withIdentifier: serviceType.storyboardIdentifier)
    }
}
