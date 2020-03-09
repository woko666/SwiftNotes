import Foundation
import Moya
import RxSwift
import Realm
import RealmSwift
import CleanroomLogger

class NotesCacheServiceRealm: NotesCacheService {
    let realmConfig = Realm.Configuration(
        schemaVersion: Config.realmSchemaVersion,
        migrationBlock: { _, _ in
    })
    
    var notes: [NoteItem] {
        get {
            do {
                let realm = try Realm(configuration: realmConfig)
                return realm.objects(NoteRealm.self).map { $0.detached() }
            } catch let error as NSError {
                Log.error?.message(error.description)
            }
            return []
        }
        
        set {
            do {
                let realm = try Realm(configuration: realmConfig)
                try realm.write {
                    realm.delete(realm.objects(NoteRealm.self))
                    newValue.forEach { realm.add(NoteRealm(id: $0.id, title: $0.title), update: .all) }
                }
            } catch let error as NSError {
                Log.error?.message(error.description)
            }
        }
    }
}
