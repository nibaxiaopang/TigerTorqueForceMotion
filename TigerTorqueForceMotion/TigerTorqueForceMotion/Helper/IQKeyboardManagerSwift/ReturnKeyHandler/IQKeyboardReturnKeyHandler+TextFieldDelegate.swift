
import UIKit

// MARK: UITextFieldDelegate
@available(iOSApplicationExtension, unavailable)
extension IQKeyboardReturnKeyHandler: UITextFieldDelegate {

    @objc public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if delegate == nil {

            if let unwrapDelegate: UITextFieldDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))) {
                    return unwrapDelegate.textFieldShouldBeginEditing?(textField) ?? false
                }
            }
        }

        return true
    }

    @objc public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        if delegate == nil {

            if let unwrapDelegate: UITextFieldDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))) {
                    return unwrapDelegate.textFieldShouldEndEditing?(textField) ?? false
                }
            }
        }

        return true
    }

    @objc public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateReturnKeyTypeOnTextField(textField)

        var aDelegate: UITextFieldDelegate? = delegate

        if aDelegate == nil {

            if let model: IQTextFieldViewInfoModel = textFieldViewCachedInfo(textField) {
                aDelegate = model.textFieldDelegate
            }
        }

        aDelegate?.textFieldDidBeginEditing?(textField)
    }

    @objc public func textFieldDidEndEditing(_ textField: UITextField) {

        var aDelegate: UITextFieldDelegate? = delegate

        if aDelegate == nil {

            if let model: IQTextFieldViewInfoModel = textFieldViewCachedInfo(textField) {
                aDelegate = model.textFieldDelegate
            }
        }

        aDelegate?.textFieldDidEndEditing?(textField)
    }

    @objc public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {

        var aDelegate: UITextFieldDelegate? = delegate

        if aDelegate == nil {

            if let model: IQTextFieldViewInfoModel = textFieldViewCachedInfo(textField) {
                aDelegate = model.textFieldDelegate
            }
        }

        aDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }

    @objc public func textField(_ textField: UITextField,
                                shouldChangeCharactersIn range: NSRange,
                                replacementString string: String) -> Bool {

        if delegate == nil {

            if let unwrapDelegate: UITextFieldDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                let selector: Selector = #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:
                                                                                    replacementString:))
                if unwrapDelegate.responds(to: selector) {
                    return unwrapDelegate.textField?(textField,
                                                     shouldChangeCharactersIn: range,
                                                     replacementString: string) ?? false
                }
            }
        }
        return true
    }

    @objc public func textFieldShouldClear(_ textField: UITextField) -> Bool {

        if delegate == nil {

            if let unwrapDelegate: UITextFieldDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:))) {
                    return unwrapDelegate.textFieldShouldClear?(textField) ?? false
                }
            }
        }

        return true
    }

    @objc public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        var isReturn: Bool = true

        if delegate == nil {

            if let unwrapDelegate: UITextFieldDelegate = textFieldViewCachedInfo(textField)?.textFieldDelegate {
                if unwrapDelegate.responds(to: #selector(UITextFieldDelegate.textFieldShouldReturn(_:))) {
                    isReturn = unwrapDelegate.textFieldShouldReturn?(textField) ?? false
                }
            }
        }

        if isReturn {
            goToNextResponderOrResign(textField)
            return true
        } else {
            return goToNextResponderOrResign(textField)
        }
    }
}
