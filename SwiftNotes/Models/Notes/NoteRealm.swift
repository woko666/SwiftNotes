import Foundation
import Realm
import RealmSwift

class NoteRealm: Object, NoteItem {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    
    required init() {}
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
