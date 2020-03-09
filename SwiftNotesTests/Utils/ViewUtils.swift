import Foundation
import UIKit

class ViewUtils {
}

extension UIView {
    func getSubviewVCs<T: UIViewController>(vcType: T.Type) -> [T] {
        var res: [T] = []
        
        for subview in self.subviews {
            res += subview.getSubviewVCs(vcType: vcType)
            
            if let vc = subview.parentViewController as? T {
                res.append(vc)
            }
        }
        
        return res
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func getSubviews<T: UIView>(_ viewType: T.Type) -> [T] {
        var res: [T] = []
        
        for subview in self.subviews {
            res += subview.getSubviews(viewType)
            if let tableView = subview as? UITableView {
                for i in 0..<tableView.numberOfSections {
                    for j in 0..<tableView.numberOfRows(inSection: i) {
                        if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                            res += cell.contentView.getSubviews(viewType)
                        }
                    }
                }
            }
            
            if let vc = subview as? T {
                res.append(vc)
            }
        }
        
        return res
    }
    
    func matchSubviews<T: UIView>(_ viewType: T.Type, equals: @escaping(T) -> Bool) -> [T] {
        return getSubviews(viewType).filter(equals)
    }
    
    func getSubviewsDirect<T: UIView>(viewType: T.Type) -> [T] {
        var res: [T] = []
        
        for subview in self.subviews {
            if let vc = subview as? T {
                res.append(vc)
            }
        }
        
        return res
    }
    
    func getTableNumOfRows() -> Int {
        for subview in self.subviews {
            let res = subview.getTableNumOfRows()
            if res > 0 {
                return res
            }
            
            if let tableView = subview as? UITableView {
                var res = 0
                for i in 0..<tableView.numberOfSections {
                    res += tableView.numberOfRows(inSection: i)
                }
                if res > 0 {
                    return res
                }
            }
        }
        
        return 0
    }
}
