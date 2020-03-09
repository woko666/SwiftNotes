import Foundation

class TestAssets {
    static func getText(_ name: String, ext: String) -> String {
        return String(data: getData(name, ext: ext), encoding: .utf8)!
    }
    
    static func getData(_ name: String, ext: String) -> Data {
        let bundle = Bundle(for: TestAssets.self)
        let path = bundle.path(forResource: name, ofType: ext)!
        return NSData(contentsOfFile: path)! as Data
    }
}
