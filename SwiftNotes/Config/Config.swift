import Foundation
import UIKit

class Config {
    static let realmSchemaVersion: UInt64 = 1
    static let backendBaseUrl = "http://woko.info/notes/" // "http://private-9aad-note10.apiary-mock.com/"
}

class TextConfig {
    static let navigationTitleLarge = FontFamily.OpenSans.bold.font(size: 17)!
}
