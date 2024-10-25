
import UIKit

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {

    @available(*, unavailable, renamed: "resignOnTouchOutside")
    @objc var shouldResignOnTouchOutside: Bool {
        get { false }
        set { }
    }

    @available(*, unavailable, renamed: "playInputClicks")
    @objc var shouldPlayInputClicks: Bool {
        get { false }
        set { }
    }

    @available(*, unavailable, message: "This feature has been removed due to few compatibility problems")
    @objc func registerTextFieldViewClass(_ aClass: UIView.Type,
                                          didBeginEditingNotificationName: String,
                                          didEndEditingNotificationName: String) {
    }

    @available(*, unavailable, message: "This feature has been removed due to few compatibility problems")
    @objc func unregisterTextFieldViewClass(_ aClass: UIView.Type,
                                            didBeginEditingNotificationName: String,
                                            didEndEditingNotificationName: String) {
    }
}

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {

    @available(*, unavailable, renamed: "toolbarConfiguration.manageBehavior")
    @objc var toolbarManageBehaviour: IQAutoToolbarManageBehavior {
        get { .bySubviews }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.useTextFieldTintColor")
    @objc var shouldToolbarUsesTextFieldTintColor: Bool {
        get { false }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.tintColor")
    @objc var toolbarTintColor: UIColor? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.barTintColor")
    @objc var toolbarBarTintColor: UIColor? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.previousNextDisplayMode")
    @objc var previousNextDisplayMode: IQPreviousNextDisplayMode {
        get { .default }
        set { }
    }
}

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {
    @available(*, unavailable, renamed: "toolbarConfiguration.previousBarButtonConfiguration.image",
                message: "To change, please assign a new toolbarConfiguration.previousBarButtonConfiguration")
    @objc var toolbarPreviousBarButtonItemImage: UIImage? {
        get { nil }
        set { }
    }
    @available(*, unavailable, renamed: "toolbarConfiguration.previousBarButtonConfiguration.title",
                message: "To change, please assign a new toolbarConfiguration.previousBarButtonConfiguration")
    @objc var toolbarPreviousBarButtonItemText: String? {
        get { nil }
        set { }
    }
    @available(*, unavailable, renamed: "toolbarConfiguration.previousBarButtonConfiguration.accessibilityLabel",
                message: "To change, please assign a new toolbarConfiguration.previousBarButtonConfiguration")
    @objc var toolbarPreviousBarButtonItemAccessibilityLabel: String? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.nextBarButtonConfiguration.image",
                message: "To change, please assign a new toolbarConfiguration.nextBarButtonConfiguration")
    @objc var toolbarNextBarButtonItemImage: UIImage? {
        get { nil }
        set { }
    }
    @available(*, unavailable, renamed: "toolbarConfiguration.nextBarButtonConfiguration.title",
                message: "To change, please assign a new toolbarConfiguration.nextBarButtonConfiguration")
    @objc var toolbarNextBarButtonItemText: String? {
        get { nil }
        set { }
    }
    @available(*, unavailable, renamed: "toolbarConfiguration.nextBarButtonConfiguration.accessibilityLabel",
                message: "To change, please assign a new toolbarConfiguration.nextBarButtonConfiguration")
    @objc var toolbarNextBarButtonItemAccessibilityLabel: String? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.doneBarButtonConfiguration.image",
                message: "To change, please assign a new toolbarConfiguration.doneBarButtonConfiguration")
    @objc var toolbarDoneBarButtonItemImage: UIImage? {
        get { nil }
        set { }
    }
    @available(*, unavailable, renamed: "toolbarConfiguration.doneBarButtonConfiguration.title",
                message: "To change, please assign a new toolbarConfiguration.doneBarButtonConfiguration")
    @objc var toolbarDoneBarButtonItemText: String? {
        get { nil }
        set { }
    }
    @available(*, unavailable, renamed: "toolbarConfiguration.doneBarButtonConfiguration.accessibilityLabel",
                message: "To change, please assign a new toolbarConfiguration.doneBarButtonConfiguration")
    @objc var toolbarDoneBarButtonItemAccessibilityLabel: String? {
        get { nil }
        set { }
    }
}

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {

    @available(*, unavailable, renamed: "toolbarConfiguration.placeholderConfiguration.accessibilityLabel")
    @objc var toolbarTitlBarButtonItemAccessibilityLabel: String? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.placeholderConfiguration.showPlaceholder")
    @objc var shouldShowToolbarPlaceholder: Bool {
        get { false }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.placeholderConfiguration.font")
    @objc var placeholderFont: UIFont? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.placeholderConfiguration.color")
    @objc var placeholderColor: UIColor? {
        get { nil }
        set { }
    }

    @available(*, unavailable, renamed: "toolbarConfiguration.placeholderConfiguration.buttonColor")
    @objc var placeholderButtonColor: UIColor? {
        get { nil }
        set { }
    }
}

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {

    @available(*, unavailable, renamed: "keyboardConfiguration.overrideAppearance")
    @objc var overrideKeyboardAppearance: Bool {
        get { false }
        set { }
    }

    @available(*, unavailable, renamed: "keyboardConfiguration.appearance")
    @objc var keyboardAppearance: UIKeyboardAppearance {
        get { .default }
        set { }
    }
}

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {

    typealias SizeBlock = (_ size: CGSize) -> Void

    @available(*, unavailable, message: "This feature has been moved to IQKeyboardListener, use it directly by creating new instance")
    @objc func registerKeyboardSizeChange(identifier: AnyHashable, sizeHandler: @escaping SizeBlock) {}

    @available(*, unavailable, message: "This feature has been moved to IQKeyboardListener, use it directly by creating new instance")
    @objc func unregisterKeyboardSizeChange(identifier: AnyHashable) {}

    @available(*, unavailable, message: "This feature has been moved to IQKeyboardListener, use it directly by creating new instance")
    @objc var keyboardShowing: Bool { false }

    @available(*, unavailable, message: "This feature has been moved to IQKeyboardListener, use it directly by creating new instance")
    @objc var keyboardFrame: CGRect { .zero }
}
