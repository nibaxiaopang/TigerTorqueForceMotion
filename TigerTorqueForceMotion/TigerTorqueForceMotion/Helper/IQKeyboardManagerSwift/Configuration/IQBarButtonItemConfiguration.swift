
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQBarButtonItemConfiguration: NSObject {

    @objc public init(systemItem: UIBarButtonItem.SystemItem, action: Selector? = nil) {
        self.systemItem = systemItem
        self.image = nil
        self.title = nil
        self.action = action
        super.init()
    }

    @objc public init(image: UIImage, action: Selector? = nil) {
        self.systemItem = nil
        self.image = image
        self.title = nil
        self.action = action
        super.init()
    }

    @objc public init(title: String, action: Selector? = nil) {
        self.systemItem = nil
        self.image = nil
        self.title = title
        self.action = action
        super.init()
    }

    public let systemItem: UIBarButtonItem.SystemItem?

    @objc public let image: UIImage?

    @objc public let title: String?

    @objc public var action: Selector?

    public override var accessibilityLabel: String? { didSet { } }

    func apply(on oldBarButtonItem: IQBarButtonItem, target: AnyObject?) -> IQBarButtonItem {

        var newBarButtonItem: IQBarButtonItem = oldBarButtonItem

        if systemItem == nil, !oldBarButtonItem.isSystemItem {
            newBarButtonItem.title = title
            newBarButtonItem.accessibilityLabel = accessibilityLabel
            newBarButtonItem.accessibilityIdentifier = newBarButtonItem.accessibilityLabel
            newBarButtonItem.image = image
            newBarButtonItem.target = target
            newBarButtonItem.action = action
        } else {
            if let systemItem: UIBarButtonItem.SystemItem = systemItem {
                newBarButtonItem = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
                newBarButtonItem.isSystemItem = true
            } else if let image: UIImage = image {
                newBarButtonItem = IQBarButtonItem(image: image, style: .plain, target: target, action: action)
            } else {
                newBarButtonItem = IQBarButtonItem(title: title, style: .plain, target: target, action: action)
            }

            newBarButtonItem.invocation = oldBarButtonItem.invocation
            newBarButtonItem.accessibilityLabel = accessibilityLabel
            newBarButtonItem.accessibilityIdentifier = oldBarButtonItem.accessibilityLabel
            newBarButtonItem.isEnabled = oldBarButtonItem.isEnabled
            newBarButtonItem.tag = oldBarButtonItem.tag
        }
        return newBarButtonItem
    }
}
