import Foundation
import UIKit

public protocol StoryboardService {
    func instantiate<ViewController: StoryboardInstantiable>(_ serviceType: ViewController.Type) -> ViewController
    func instantiateVC(_ serviceType: StoryboardInstantiable.Type) -> UIViewController
    func resolve<T: Any>(_ classType: T.Type) -> T?
}
