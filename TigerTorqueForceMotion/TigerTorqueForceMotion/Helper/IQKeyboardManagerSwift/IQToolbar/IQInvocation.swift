
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQInvocation: NSObject {
    @objc public weak var target: AnyObject?
    @objc public var action: Selector

    @objc public init(_ target: AnyObject, _ action: Selector) {
        self.target = target
        self.action = action
    }

    @objc public func invoke(from: Any) {
        if let target: AnyObject = target {
            UIApplication.shared.sendAction(action, to: target, from: from, for: UIEvent())
        }
    }
}
