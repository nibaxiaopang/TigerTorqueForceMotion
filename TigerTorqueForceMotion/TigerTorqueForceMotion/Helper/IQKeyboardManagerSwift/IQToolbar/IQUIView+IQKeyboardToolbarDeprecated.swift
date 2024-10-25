
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public extension UIView {

    @available(*, unavailable, renamed: "iq.toolbar")
    var keyboardToolbar: IQToolbar {
        get { fatalError() }
        set {}
    }

    @available(*, unavailable, renamed: "iq.hidePlaceholder")
    var shouldHideToolbarPlaceholder: Bool {
        get { false }
        set {}
    }

    @available(*, unavailable, renamed: "iq.placeholder")
    var toolbarPlaceholder: String? {
        get { nil }
        set {}
    }

    @available(*, unavailable, renamed: "iq.drawingPlaceholder")
    var drawingToolbarPlaceholder: String? {
        get { nil }
        set {}
    }

    @available(*, unavailable, renamed: "iq.addToolbar(target:previousConfiguration:nextConfiguration:rightConfiguration:title:titleAccessibilityLabel:)")
    func addKeyboardToolbarWithTarget(target: AnyObject?,
                                      titleText: String?,
                                      titleAccessibilityLabel: String? = nil,
                                      rightBarButtonConfiguration: IQBarButtonItemConfiguration?,
                                      previousBarButtonConfiguration: IQBarButtonItemConfiguration? = nil,
                                      nextBarButtonConfiguration: IQBarButtonItemConfiguration? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addDone(target:action:showPlaceholder:titleAccessibilityLabel:)")
    func addDoneOnKeyboardWithTarget(_ target: AnyObject?,
                                     action: Selector,
                                     shouldShowPlaceholder: Bool = false,
                                     titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addDone(target:action:title:titleAccessibilityLabel:)")
    func addDoneOnKeyboardWithTarget(_ target: AnyObject?,
                                     action: Selector,
                                     titleText: String?,
                                     titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightButton(target:configuration:showPlaceholder:titleAccessibilityLabel:)")
    func addRightButtonOnKeyboardWithImage(_ image: UIImage,
                                           target: AnyObject?,
                                           action: Selector,
                                           shouldShowPlaceholder: Bool = false,
                                           titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightButton(target:configuration:title:titleAccessibilityLabel:)")
    func addRightButtonOnKeyboardWithImage(_ image: UIImage,
                                           target: AnyObject?,
                                           action: Selector,
                                           titleText: String?,
                                           titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightButton(target:configuration:showPlaceholder:titleAccessibilityLabel:)")
    func addRightButtonOnKeyboardWithText(_ text: String,
                                          target: AnyObject?,
                                          action: Selector,
                                          shouldShowPlaceholder: Bool = false,
                                          titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightButton(target:configuration:title:titleAccessibilityLabel:)")
    func addRightButtonOnKeyboardWithText(_ text: String,
                                          target: AnyObject?,
                                          action: Selector,
                                          titleText: String?,
                                          titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightLeft(target:rightConfiguration:leftConfiguration:showPlaceholder:titleAccessibilityLabel:)")
    func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?,
                                           cancelAction: Selector,
                                           doneAction: Selector,
                                           shouldShowPlaceholder: Bool = false,
                                           titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightLeft(target:rightConfiguration:leftConfiguration:showPlaceholder:titleAccessibilityLabel:)")
    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?,
                                          leftButtonTitle: String,
                                          rightButtonTitle: String,
                                          leftButtonAction: Selector,
                                          rightButtonAction: Selector,
                                          shouldShowPlaceholder: Bool = false,
                                          titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightLeft(target:rightConfiguration:leftConfiguration:showPlaceholder:titleAccessibilityLabel:)")
    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?,
                                          leftButtonImage: UIImage,
                                          rightButtonImage: UIImage,
                                          leftButtonAction: Selector,
                                          rightButtonAction: Selector,
                                          shouldShowPlaceholder: Bool = false,
                                          titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightLeft(target:rightConfiguration:leftConfiguration:title:titleAccessibilityLabel:)")
    func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?,
                                           cancelAction: Selector,
                                           doneAction: Selector,
                                           titleText: String?,
                                           titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightLeft(target:rightConfiguration:leftConfiguration:title:titleAccessibilityLabel:)")
    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?,
                                          leftButtonTitle: String,
                                          rightButtonTitle: String,
                                          leftButtonAction: Selector,
                                          rightButtonAction: Selector,
                                          titleText: String?,
                                          titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addRightLeft(target:rightConfiguration:leftConfiguration:title:titleAccessibilityLabel:)")
    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?,
                                          leftButtonImage: UIImage,
                                          rightButtonImage: UIImage,
                                          leftButtonAction: Selector,
                                          rightButtonAction: Selector,
                                          titleText: String?,
                                          titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addPreviousNextDone(target:previousAction:nextAction:doneAction:showPlaceholder:titleAccessibilityLabel:)")
    func addPreviousNextDone(_ target: AnyObject?,
                             previousAction: Selector,
                             nextAction: Selector,
                             doneAction: Selector,
                             shouldShowPlaceholder: Bool = false,
                             titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addPreviousNextDone(target:previousAction:nextAction:doneAction:title:titleAccessibilityLabel:)")
    func addPreviousNextDoneOnKeyboardWithTarget(_ target: AnyObject?,
                                                 previousAction: Selector,
                                                 nextAction: Selector,
                                                 doneAction: Selector,
                                                 titleText: String?,
                                                 titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addPreviousNextRight(target:previousConfiguration:nextConfiguration:rightConfiguration:showPlaceholder:titleAccessibilityLabel:)")
    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?,
                                                  rightButtonImage: UIImage,
                                                  previousAction: Selector,
                                                  nextAction: Selector,
                                                  rightButtonAction: Selector,
                                                  shouldShowPlaceholder: Bool = false,
                                                  titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addPreviousNextRight(target:previousConfiguration:nextConfiguration:rightConfiguration:showPlaceholder:titleAccessibilityLabel:)")
    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?,
                                                  rightButtonTitle: String,
                                                  previousAction: Selector,
                                                  nextAction: Selector,
                                                  rightButtonAction: Selector,
                                                  shouldShowPlaceholder: Bool = false,
                                                  titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addPreviousNextRight(target:previousConfiguration:nextConfiguration:rightConfiguration:title:titleAccessibilityLabel:)")
    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?,
                                                  rightButtonImage: UIImage,
                                                  previousAction: Selector,
                                                  nextAction: Selector,
                                                  rightButtonAction: Selector,
                                                  titleText: String?,
                                                  titleAccessibilityLabel: String? = nil) {
    }

    @available(*, unavailable, renamed: "iq.addPreviousNextRight(target:previousConfiguration:nextConfiguration:rightConfiguration:title:titleAccessibilityLabel:)")
    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?,
                                                  rightButtonTitle: String,
                                                  previousAction: Selector,
                                                  nextAction: Selector,
                                                  rightButtonAction: Selector,
                                                  titleText: String?,
                                                  titleAccessibilityLabel: String? = nil) {
    }
}
