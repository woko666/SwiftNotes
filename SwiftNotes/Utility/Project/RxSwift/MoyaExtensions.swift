import Foundation
import RxSwift
import RxCocoa
import Moya
import CleanroomLogger

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    /// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
    public func mapJson<D: Decodable>(_ type: D.Type, method: String? = nil, dateFormatter: DateFormatter? = nil) -> Single<D> {
        return flatMap {
            do {
                return .just(try JSONDecoder().decode(type, from: $0.data))
            } catch let error {
                return .error(JsonError.parseError(endpoint: method, data: String(data: $0.data, encoding: .utf8) ?? "", error: JsonError.formatValueHumanReadable(error)))
            }
        }
    }
    
    /// Filters out responses where `statusCode` falls within the range 200 - 299.
    public func checkStatusCode() -> Single<Element> {
        return flatMap {
            if $0.statusCode >= 200 && $0.statusCode < 300 {
                return .just($0)
            } else {
                return .error(NetworkError.statusCodeError(code: $0.statusCode))
            }
        }
    }
}
