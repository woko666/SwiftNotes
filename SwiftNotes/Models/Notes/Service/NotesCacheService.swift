import Foundation
import RxSwift
import RxRelay

protocol NotesCacheService: class {
    var notes: [NoteItem] { get set }
}
