
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQToolbarConfiguration: NSObject {

    @objc public var useTextFieldTintColor: Bool = false

    @objc public var tintColor: UIColor?

    @objc public var barTintColor: UIColor?

    @objc public var previousNextDisplayMode: IQPreviousNextDisplayMode = .default

    @objc public var manageBehavior: IQAutoToolbarManageBehavior = .bySubviews

    @objc public var previousBarButtonConfiguration: IQBarButtonItemConfiguration?
    @objc public var nextBarButtonConfiguration: IQBarButtonItemConfiguration?
    @objc public var doneBarButtonConfiguration: IQBarButtonItemConfiguration?

    @objc public let placeholderConfiguration: IQToolbarPlaceholderConfiguration = .init()
}
