
import UIKit

// MARK: Previous next button actions
@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {

    @objc var canGoPrevious: Bool {

        guard let textFields: [UIView] = responderViews(),
              let textFieldRetain: UIView = activeConfiguration.textFieldViewInfo?.textFieldView,
              let index: Int = textFields.firstIndex(of: textFieldRetain),
              index > 0 else {
            return false
        }
        return true
    }

    @objc var canGoNext: Bool {

        guard let textFields: [UIView] = responderViews(),
              let textFieldRetain: UIView = activeConfiguration.textFieldViewInfo?.textFieldView,
              let index: Int = textFields.firstIndex(of: textFieldRetain),
                index < textFields.count-1 else {
            return false
        }
        return true
    }

    @discardableResult
    @objc func goPrevious() -> Bool {

        guard let textFields: [UIView] = responderViews(),
              let textFieldRetain: UIView = activeConfiguration.textFieldViewInfo?.textFieldView,
              let index: Int = textFields.firstIndex(of: textFieldRetain),
              index > 0 else {
            return false
        }

        let nextTextField: UIView = textFields[index-1]

        let isAcceptAsFirstResponder: Bool = nextTextField.becomeFirstResponder()

        if !isAcceptAsFirstResponder {
            showLog("Refuses to become first responder: \(nextTextField)")
        }

        return isAcceptAsFirstResponder
    }

    @discardableResult
    @objc func goNext() -> Bool {

        guard let textFields: [UIView] = responderViews(),
              let textFieldRetain: UIView = activeConfiguration.textFieldViewInfo?.textFieldView,
              let index: Int = textFields.firstIndex(of: textFieldRetain),
                index < textFields.count-1 else {
            return false
        }

        let nextTextField: UIView = textFields[index+1]

        let isAcceptAsFirstResponder: Bool = nextTextField.becomeFirstResponder()

        if !isAcceptAsFirstResponder {
            showLog("Refuses to become first responder: \(nextTextField)")
        }

        return isAcceptAsFirstResponder
    }

    @objc internal func previousAction (_ barButton: IQBarButtonItem) {

        if playInputClicks {

            UIDevice.current.playInputClick()
        }

        guard canGoPrevious,
              let textFieldRetain: UIView = activeConfiguration.textFieldViewInfo?.textFieldView else {
            return
        }

        let isAcceptAsFirstResponder: Bool = goPrevious()

        var invocation: IQInvocation? = barButton.invocation
        var sender: UIView = textFieldRetain

        do {
            if let searchBar: UIView = textFieldRetain.iq.textFieldSearchBar() {
                invocation = searchBar.iq.toolbar.previousBarButton.invocation
                sender = searchBar
            }
        }

        if isAcceptAsFirstResponder {
            invocation?.invoke(from: sender)
        }
    }

    @objc internal func nextAction (_ barButton: IQBarButtonItem) {

        if playInputClicks {

            UIDevice.current.playInputClick()
        }

        guard canGoNext,
              let textFieldRetain: UIView = activeConfiguration.textFieldViewInfo?.textFieldView else {
            return
        }

        let isAcceptAsFirstResponder: Bool = goNext()

        var invocation: IQInvocation? = barButton.invocation
        var sender: UIView = textFieldRetain

        do {
            if let searchBar: UIView = textFieldRetain.iq.textFieldSearchBar() {
                invocation = searchBar.iq.toolbar.nextBarButton.invocation
                sender = searchBar
            }
        }

        if isAcceptAsFirstResponder {
            invocation?.invoke(from: sender)
        }
    }

    @objc internal func doneAction (_ barButton: IQBarButtonItem) {

        if playInputClicks {

            UIDevice.current.playInputClick()
        }

        guard let textFieldRetain: UIView = activeConfiguration.textFieldViewInfo?.textFieldView else {
            return
        }

        let isResignedFirstResponder: Bool = resignFirstResponder()

        var invocation: IQInvocation? = barButton.invocation
        var sender: UIView = textFieldRetain

        do {
            if let searchBar: UIView = textFieldRetain.iq.textFieldSearchBar() {
                invocation = searchBar.iq.toolbar.doneBarButton.invocation
                sender = searchBar
            }
        }

        if isResignedFirstResponder {
            invocation?.invoke(from: sender)
        }
    }
}
