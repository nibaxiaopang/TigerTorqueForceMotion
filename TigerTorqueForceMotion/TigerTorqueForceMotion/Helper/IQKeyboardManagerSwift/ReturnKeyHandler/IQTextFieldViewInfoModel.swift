
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
internal final class IQTextFieldViewInfoModel: NSObject {

    weak var textFieldDelegate: UITextFieldDelegate?
    weak var textViewDelegate: UITextViewDelegate?
    weak var textFieldView: UIView?
    let originalReturnKeyType: UIReturnKeyType

    init(textField: UITextField) {
        self.textFieldView = textField
        self.textFieldDelegate = textField.delegate
        self.originalReturnKeyType = textField.returnKeyType
    }

    init(textView: UITextView) {
        self.textFieldView = textView
        self.textViewDelegate = textView.delegate
        self.originalReturnKeyType = textView.returnKeyType
    }

    func restore() {
        if let textField = textFieldView as? UITextField {
            textField.returnKeyType = originalReturnKeyType
            textField.delegate = textFieldDelegate
        } else if let textView = textFieldView as? UITextView {
            textView.returnKeyType = originalReturnKeyType
            textView.delegate = textViewDelegate
        }
    }
}
