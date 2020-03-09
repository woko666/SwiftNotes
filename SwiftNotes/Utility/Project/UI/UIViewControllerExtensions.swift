import Foundation
import UIKit
import SnapKit
import PopupDialog

extension UIViewController {
    func showOkDialog(title: String, message: String, callback: (() -> Void)? = nil) {
        let button = DefaultButton(title: L10n.ok, action: nil)
        let popup = PopupDialog(title: title, message: message, completion: callback)
        popup.buttonAlignment = .horizontal
        popup.addButtons([button])
        popup.transitionStyle = .fadeIn
        
        present(popup, animated: true, completion: nil)
    }
    
    func showYesNoDialog(title: String, message: String, yes: String, no: String, callback: @escaping (Bool) -> Void) {
        let yesButton = DefaultButton(title: yes, action: {
            callback(true)
        })
        let noButton = CancelButton(title: no, action: {
            callback(false)
        })
        let popup = PopupDialog(title: title, message: message)
        popup.buttonAlignment = .horizontal
        popup.addButtons([noButton, yesButton])
        popup.transitionStyle = .fadeIn
        
        present(popup, animated: true, completion: nil)
    }
}
