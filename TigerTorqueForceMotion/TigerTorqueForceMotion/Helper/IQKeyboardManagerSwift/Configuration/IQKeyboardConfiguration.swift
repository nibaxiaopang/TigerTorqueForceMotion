
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQKeyboardConfiguration: NSObject {

    @objc public var overrideAppearance: Bool = false

    @objc public var appearance: UIKeyboardAppearance = UIKeyboardAppearance.default
}
