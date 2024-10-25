
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQToolbarPlaceholderConfiguration: NSObject {

    @objc public var showPlaceholder: Bool = true

    @objc public var font: UIFont?

    @objc public var color: UIColor?

    @objc public var buttonColor: UIColor?

    public override var accessibilityLabel: String? { didSet { } }
}
