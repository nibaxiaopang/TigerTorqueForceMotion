
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc open class IQBarButtonItem: UIBarButtonItem {

    internal static let flexibleBarButtonItem: IQBarButtonItem = IQBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                                                 target: nil, action: nil)

    @objc public override init() {
        super.init()
        initialize()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {

        let states: [UIControl.State] = [.normal, .highlighted, .disabled, .focused]

        for state in states {

            setBackgroundImage(UIImage(), for: state, barMetrics: .default)
            setBackgroundImage(UIImage(), for: state, style: .plain, barMetrics: .default)
            setBackButtonBackgroundImage(UIImage(), for: state, barMetrics: .default)
        }

        setTitlePositionAdjustment(UIOffset(), for: .default)
        setBackgroundVerticalPositionAdjustment(0, for: .default)
        setBackButtonBackgroundVerticalPositionAdjustment(0, for: .default)
    }

    @objc override open var tintColor: UIColor? {
        didSet {

            var textAttributes: [NSAttributedString.Key: Any] = [:]
            textAttributes[.foregroundColor] = tintColor

            if let attributes: [NSAttributedString.Key: Any] = titleTextAttributes(for: .normal) {
                for (key, value) in attributes {
                    textAttributes[key] = value
                }
            }

            setTitleTextAttributes(textAttributes, for: .normal)
        }
    }

    internal var isSystemItem: Bool = false

    @objc open func setTarget(_ target: AnyObject?, action: Selector?) {
        if let target: AnyObject = target, let action: Selector = action {
            invocation = IQInvocation(target, action)
        } else {
            invocation = nil
        }
    }

    @objc open var invocation: IQInvocation? {
        didSet {
            
            if let titleBarButton = self as? IQTitleBarButtonItem {

                if let target = invocation?.target, let action = invocation?.action {
                    titleBarButton.isEnabled = true
                    titleBarButton.titleButton?.isEnabled = true
                    titleBarButton.titleButton?.addTarget(target, action: action, for: .touchUpInside)
                } else {
                    titleBarButton.isEnabled = false
                    titleBarButton.titleButton?.isEnabled = false
                    titleBarButton.titleButton?.removeTarget(nil, action: nil, for: .touchUpInside)
                }
            }
        }
    }
}
