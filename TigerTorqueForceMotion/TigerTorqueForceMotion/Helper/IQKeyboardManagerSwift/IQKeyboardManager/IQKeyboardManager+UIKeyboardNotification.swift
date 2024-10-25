
import UIKit

// MARK: UIKeyboard Notifications
@available(iOSApplicationExtension, unavailable)
internal extension IQKeyboardManager {

    func handleKeyboardTextFieldViewVisible() {
        if self.activeConfiguration.rootControllerConfiguration == nil {

            let rootConfiguration: IQRootControllerConfiguration? = self.activeConfiguration.rootControllerConfiguration
            if let gestureConfiguration = self.rootConfigurationWhilePopGestureActive,
               gestureConfiguration.rootController == rootConfiguration?.rootController {
                self.activeConfiguration.rootControllerConfiguration = gestureConfiguration
            }

            self.rootConfigurationWhilePopGestureActive = nil

            if let configuration = self.activeConfiguration.rootControllerConfiguration {
                let classNameString: String = "\(type(of: configuration.rootController.self))"
                self.showLog("Saving \(classNameString) beginning origin: \(configuration.beginOrigin)")
            }
        }

        setupTextFieldView()

        if !privateIsEnabled() {
            restorePosition()
        } else {
            adjustPosition()
        }
    }

    func handleKeyboardTextFieldViewChanged() {

        setupTextFieldView()

        if !privateIsEnabled() {
            restorePosition()
        } else {
            adjustPosition()
        }
    }

    func handleKeyboardTextFieldViewHide() {

        self.restorePosition()
        self.banishTextFieldViewSetup()

        if let configuration = self.activeConfiguration.rootControllerConfiguration,
           configuration.rootController.navigationController?.interactivePopGestureRecognizer?.state == .began {
            self.rootConfigurationWhilePopGestureActive = configuration
        }

        self.lastScrollViewConfiguration = nil
    }
}

@available(iOSApplicationExtension, unavailable)
internal extension IQKeyboardManager {

    func setupTextFieldView() {

        guard let textFieldView = activeConfiguration.textFieldViewInfo?.textFieldView else {
            return
        }

        do {
            if let startingConfiguration = startingTextViewConfiguration,
               startingConfiguration.hasChanged {

                if startingConfiguration.scrollView.contentInset != startingConfiguration.startingContentInset {
                    showLog("Restoring textView.contentInset to: \(startingConfiguration.startingContentInset)")
                }

                activeConfiguration.animate(alongsideTransition: {
                    startingConfiguration.restore(for: textFieldView)
                })
            }
            startingTextViewConfiguration = nil
        }

        if keyboardConfiguration.overrideAppearance,
           let textInput: UITextInput = textFieldView as? UITextInput,
            textInput.keyboardAppearance != keyboardConfiguration.appearance {

            if let textFieldView: UITextField = textFieldView as? UITextField {
                textFieldView.keyboardAppearance = keyboardConfiguration.appearance
            } else if  let textFieldView: UITextView = textFieldView as? UITextView {
                textFieldView.keyboardAppearance = keyboardConfiguration.appearance
            }
            textFieldView.reloadInputViews()
        }

        reloadInputViews()

        resignFirstResponderGesture.isEnabled = privateResignOnTouchOutside()
        textFieldView.window?.addGestureRecognizer(resignFirstResponderGesture)
    }

    func banishTextFieldViewSetup() {

        guard let textFieldView = activeConfiguration.textFieldViewInfo?.textFieldView else {
            return
        }

        textFieldView.window?.removeGestureRecognizer(resignFirstResponderGesture)

        do {
            if let startingConfiguration = startingTextViewConfiguration,
               startingConfiguration.hasChanged {

                if startingConfiguration.scrollView.contentInset != startingConfiguration.startingContentInset {
                    showLog("Restoring textView.contentInset to: \(startingConfiguration.startingContentInset)")
                }

                activeConfiguration.animate(alongsideTransition: {
                    startingConfiguration.restore(for: textFieldView)
                })
            }
            startingTextViewConfiguration = nil
        }
    }
}
