import Foundation
import RxSwift
import RxCocoa

class ObservableRecorder<T> {
    var items = [T]()
    let bag = DisposeBag()
    
    init(arraySubject: Observable<[T]>) {
        arraySubject.subscribe(onNext: { value in
            self.items = value
        }).disposed(by: bag)
    }
    
    init(valueSubject: Observable<T>) {
        valueSubject.subscribe(onNext: { value in
            self.items.append(value)
        }).disposed(by: bag)
    }
    
    func first() throws -> T {
        if let first = items.first {
            return first
        }
        throw TestError.runtimeError
    }
    
    func second() throws -> T {
        if items.count > 1 {
            return items[1]
        }
        throw TestError.runtimeError
    }
    
    func nth(_ index: Int) throws -> T {
        if items.count >= index {
            return items[index]
        }
        throw TestError.runtimeError
    }
    
    func last() throws -> T {
        if let last = items.last {
            return last
        }
        throw TestError.runtimeError
    }
    
    func all() -> [T] {
        return items
    }
    
    func contains(_ equals: @escaping(T) -> Bool) -> Bool {
        items.first(where: equals) != nil
    }
}
