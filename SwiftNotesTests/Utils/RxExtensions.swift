import Foundation
import Quick
import Nimble
import RxSwift
import RxBlocking

extension QuickSpec {
    // https://medium.com/@Tovkal/testing-enums-with-associated-values-using-nimble-839b0e53128
    func beEqual<T>(_ equals: @escaping (T) -> Bool) -> Predicate<T> {
        return Predicate.define("be <equal to predicate>") { expression, message in
            if let actual = try expression.evaluate() {
                if equals(actual) {
                    return PredicateResult(status: .matches, message: message)
                } else {
                    return PredicateResult(status: .fail, message: message)
                }
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    func beError<T>() -> Predicate<MaterializedSequenceResult<T>> {
        return Predicate.define("be <failed>") { expression, message in
            if let actual = try expression.evaluate(), case .failed = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    func beCompleted<T>() -> Predicate<MaterializedSequenceResult<T>> {
        return Predicate.define("be <completed>") { expression, message in
            if let actual = try expression.evaluate(), case .completed = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    func containsInCompleted<T>(_ compare: @escaping (T) -> Bool) -> Predicate<MaterializedSequenceResult<T>> {
        return Predicate.define("contains <predicate>") { expression, message in
            if let actual = try expression.evaluate(), case .completed(let values) = actual, values.first(where: { compare($0) }) != nil {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
}
