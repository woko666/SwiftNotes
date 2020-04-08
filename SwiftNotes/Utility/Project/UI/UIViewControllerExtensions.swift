import Foundation
import UIKit
import SnapKit

extension UIViewController {
    func showOkDialog(title: String, message: String, callback: (() -> Void)? = nil) {
        AlertManager.okAlert(self, title: title, message: message, ok: L10n.ok, callback: callback)
    }
    
    func showYesNoDialog(title: String, message: String, yes: String, no: String, callback: @escaping (Bool) -> Void) {
        AlertManager.yesNoAlert(self, title: title, message: message, yes: yes, no: no, yesCallback: {
            callback(true)
        }, noCallback: {
            callback(false)
        })
    }
}
