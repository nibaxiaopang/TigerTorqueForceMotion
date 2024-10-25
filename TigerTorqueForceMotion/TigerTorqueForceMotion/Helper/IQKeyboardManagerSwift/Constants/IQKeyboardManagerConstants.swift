
import Foundation

// MARK: IQAutoToolbarManageBehavior

@available(iOSApplicationExtension, unavailable)
@objc public enum IQAutoToolbarManageBehavior: Int {
    case bySubviews
    case byTag
    case byPosition
}

@available(iOSApplicationExtension, unavailable)
@objc public enum IQPreviousNextDisplayMode: Int {
    case `default`
    case alwaysHide
    case alwaysShow
}

@available(iOSApplicationExtension, unavailable)
@objc public enum IQEnableMode: Int {
    case `default`
    case enabled
    case disabled
}
