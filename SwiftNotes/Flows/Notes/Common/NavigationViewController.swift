import UIKit
import Foundation

public class NavigationViewController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = ColorName.backgroundColor.color
        navigationBar.tintColor = ColorName.mainTint.color
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = [.foregroundColor: ColorName.defaultText.color]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: ColorName.defaultText.color]
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: TextConfig.navigationTitleLarge], for: .normal)
    }
}
