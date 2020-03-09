/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

public protocol Coordinator: class {
    var parent: Coordinator? { get }
    var children: [Coordinator] { get set }
    var router: Router { get }
    
    func present(animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
    func onMessage(_ message: CoordinatorMessageBase, direction: CoordinatorMessageDirection)
}

extension Coordinator {
    public func dismiss(animated: Bool) {
        children.forEach { $0.dismiss(animated: animated) }
        children = []
        router.dismiss(animated: true)
    }

    public func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)? = nil) {
        children.append(child)
        child.present(animated: animated, onDismissed: { [weak self, weak child] in
            guard let self = self, let child = child else { return }
            self.removeChild(child)
            onDismissed?()
        })
    }
    
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child }) else {
            return
        }
        children.remove(at: index)
    }
    
    public func present(animated: Bool) {
        present(animated: animated, onDismissed: nil)
    }
    
    public func sendMessage(_ message: CoordinatorMessageBase, direction: CoordinatorMessageDirection) {
        onMessagePass(message, direction: direction)
    }
    
    // protected, but swift doesn't support it, so... public :(
    public func onMessage(_ message: CoordinatorMessageBase, direction: CoordinatorMessageDirection) {
        onMessagePass(message, direction: direction)
    }
    
    // protected, but swift doesn't support it, so... public :(
    public func onMessagePass(_ message: CoordinatorMessageBase, direction: CoordinatorMessageDirection) {
        // pass upstream / downstream
        if case .down = direction {
            children.forEach { $0.onMessage(message, direction: direction) }
        } else {
            parent?.onMessage(message, direction: direction)
        }
    }
    
    // protected, but swift doesn't support it, so... public :(
    public func convertOrPass<T>(_ message: CoordinatorMessageBase, direction: CoordinatorMessageDirection, type: T.Type) -> T? {
        if let message = message as? T {
            return message
        }
        
        onMessagePass(message, direction: direction)
        return nil
    }
}

public enum CoordinatorMessageDirection {
    case up
    case down
}

public protocol CoordinatorMessageBase {
}
