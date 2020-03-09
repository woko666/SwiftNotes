import Foundation
import Moya
import RxSwift
import Realm
import RealmSwift
@testable import Swift_Notes

class NotesCacheServiceMock: NotesCacheService {
    var notes: [NoteItem] = []
}
