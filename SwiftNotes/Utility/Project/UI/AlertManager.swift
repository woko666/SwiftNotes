//
//  AlertManager.swift
//  SwiftNotes
//
//  Created by woko on 08/04/2020.
//  Copyright © 2020 Woko. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    private var parentVC: UIViewController
    private var title: String?
    private var message: String?
    var actions: [UIAlertAction] = []
    
    init(_ parentVC: UIViewController, title: String? = nil, message: String? = nil) {
        self.parentVC = parentVC
        self.title = title
        self.message = message
    }
    
    func present(animated: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        parentVC.present(alert, animated: animated, completion: completion)
    }
    
    static func yesNoAlert(_ parentVC: UIViewController, title: String? = nil, message: String? = nil, yes: String, no: String, yesCallback: (() -> Void)? = nil, noCallback: (() -> Void)? = nil) {
        let cancelAction = UIAlertAction(title: no, style: .cancel) { _ in
            noCallback?()
        }
        let confirmAction = UIAlertAction(title: yes, style: .default) { _ in
            yesCallback?()
        }
        
        let alert = AlertManager(parentVC, title: title, message: message)
        alert.actions = [confirmAction, cancelAction]
        alert.present()
    }
    
    static func okAlert(_ parentVC: UIViewController, title: String? = nil, message: String? = nil, ok: String = "OK", callback: (() -> Void)? = nil) {
        let okAction = UIAlertAction(title: ok, style: .cancel) { _ in
            callback?()
        }
        
        let alert = AlertManager(parentVC, title: title, message: message)
        alert.actions = [okAction]
        alert.present()
    }
}
