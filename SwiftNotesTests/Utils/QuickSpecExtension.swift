import Foundation
import Quick
import Nimble
import RealmSwift
@testable import Swift_Notes

extension QuickSpec {
    var windowViews: [UIView] {
        return UIApplication.shared.keyWindow!.subviews
    }
}
