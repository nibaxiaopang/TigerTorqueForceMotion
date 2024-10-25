
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQKeyboardReturnKeyHandler: NSObject {

    // MARK: Settings

    @objc public weak var delegate: (UITextFieldDelegate & UITextViewDelegate)?

    @objc public var lastTextFieldReturnKeyType: UIReturnKeyType = UIReturnKeyType.default {

        didSet {
            for model in textFieldInfoCache {
                if let view: UIView = model.textFieldView {
                    updateReturnKeyTypeOnTextField(view)
                }
            }
        }
    }

    // MARK: Initialization/De-initialization

    @objc public override init() {
        super.init()
    }

    @objc public init(controller: UIViewController) {
        super.init()

        addResponderFromView(controller.view)
    }

    deinit {

        textFieldInfoCache.removeAll()
    }

    // MARK: Private variables
    private var textFieldInfoCache: [IQTextFieldViewInfoModel] = []

    // MARK: Private Functions
    internal func textFieldViewCachedInfo(_ textField: UIView) -> IQTextFieldViewInfoModel? {

        for model in textFieldInfoCache {

            if let view: UIView = model.textFieldView {
                if view == textField {
                    return model
                }
            }
        }

        return nil
    }

    internal func updateReturnKeyTypeOnTextField(_ view: UIView) {
        var superConsideredView: UIView?

        for allowedClasse in IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses {

            superConsideredView = view.iq.superviewOf(type: allowedClasse)

            if superConsideredView != nil {
                break
            }
        }

        var textFields: [UIView] = []

        if let unwrappedTableView: UIView = superConsideredView {     //   (Enhancement ID: #22)
            textFields = unwrappedTableView.iq.deepResponderViews()
        } else {
            textFields = view.iq.responderSiblings()

            switch IQKeyboardManager.shared.toolbarConfiguration.manageBehavior {

            case .byTag:        textFields = textFields.sortedByTag()

            case .byPosition:   textFields = textFields.sortedByPosition()
            default:    break
            }
        }

        if let lastView: UIView = textFields.last {

            if let textField: UITextField = view as? UITextField {

                textField.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType: UIReturnKeyType.next
            } else if let textView: UITextView = view as? UITextView {

                textView.returnKeyType = (view == lastView)    ?   lastTextFieldReturnKeyType: UIReturnKeyType.next
            }
        }
    }

    // MARK: Registering/Unregistering textFieldView

    @objc public func addTextFieldView(_ view: UIView) {

        if let textField: UITextField = view as? UITextField {
            let model = IQTextFieldViewInfoModel(textField: textField)
            textFieldInfoCache.append(model)
            textField.delegate = self

        } else if let textView: UITextView = view as? UITextView {
            let model = IQTextFieldViewInfoModel(textView: textView)
            textFieldInfoCache.append(model)
            textView.delegate = self
        }
    }

    @objc public func removeTextFieldView(_ view: UIView) {

        if let model: IQTextFieldViewInfoModel = textFieldViewCachedInfo(view) {
            model.restore()

            if let index: Int = textFieldInfoCache.firstIndex(where: { $0.textFieldView == view}) {
                textFieldInfoCache.remove(at: index)
            }
        }
    }

    @objc public func addResponderFromView(_ view: UIView) {

        let textFields: [UIView] = view.iq.deepResponderViews()

        for textField in textFields {

            addTextFieldView(textField)
        }
    }

    @objc public func removeResponderFromView(_ view: UIView) {

        let textFields: [UIView] = view.iq.deepResponderViews()

        for textField in textFields {

            removeTextFieldView(textField)
        }
    }

    @discardableResult
    internal func goToNextResponderOrResign(_ view: UIView) -> Bool {

        var superConsideredView: UIView?

        for allowedClass in IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses {

            superConsideredView = view.iq.superviewOf(type: allowedClass)

            if superConsideredView != nil {
                break
            }
        }

        var textFields: [UIView] = []

        if let unwrappedTableView: UIView = superConsideredView {
            textFields = unwrappedTableView.iq.deepResponderViews()
        } else {

            textFields = view.iq.responderSiblings()

            switch IQKeyboardManager.shared.toolbarConfiguration.manageBehavior {

            case .byTag:        textFields = textFields.sortedByTag()

            case .byPosition:   textFields = textFields.sortedByPosition()
            default:
                break
            }
        }

        if let index: Int = textFields.firstIndex(of: view) {

            if index < (textFields.count - 1) {

                let nextTextField: UIView = textFields[index+1]
                nextTextField.becomeFirstResponder()
                return false
            } else {

                view.resignFirstResponder()
                return true
            }
        } else {
            return true
        }
    }
}
