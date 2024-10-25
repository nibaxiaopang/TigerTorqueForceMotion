
import UIKit

@available(iOSApplicationExtension, unavailable)
internal extension IQKeyboardManager {

    func responderViews() -> [UIView]? {

        guard let textFieldView: UIView = activeConfiguration.textFieldViewInfo?.textFieldView else {
            return nil
        }

        var superConsideredView: UIView?

        for allowedClass in toolbarPreviousNextAllowedClasses {
            superConsideredView = textFieldView.iq.superviewOf(type: allowedClass)
            if superConsideredView != nil {
                break
            }
        }

        var swiftUIHostingView: UIView?
        let swiftUIHostingViewName: String = "UIHostingView<"
        var superView: UIView? = textFieldView.superview
        while let unwrappedSuperView: UIView = superView {

            let classNameString: String = {
                var name: String = "\(type(of: unwrappedSuperView.self))"
                if name.hasPrefix("_") {
                    name.removeFirst()
                }
                return name
            }()

            if classNameString.hasPrefix(swiftUIHostingViewName) {
                swiftUIHostingView = unwrappedSuperView
                break
            }

            superView = unwrappedSuperView.superview
        }

        if let view: UIView = swiftUIHostingView {
            return view.iq.deepResponderViews()
        } else if let view: UIView = superConsideredView {
            return view.iq.deepResponderViews()
        } else {

            let textFields: [UIView] = textFieldView.iq.responderSiblings()

            switch toolbarConfiguration.manageBehavior {

            case .bySubviews:   return textFields

            case .byTag:    return textFields.sortedByTag()

            case .byPosition:    return textFields.sortedByPosition()
            }
        }
    }

    func privateIsEnabled() -> Bool {

        var isEnabled: Bool = enable

        guard let textFieldViewInfo: IQTextFieldViewInfo = activeConfiguration.textFieldViewInfo else {
            return isEnabled
        }

        let enableMode: IQEnableMode = textFieldViewInfo.textFieldView.iq.enableMode

        if enableMode == .enabled {
            isEnabled = true
        } else if enableMode == .disabled {
            isEnabled = false
        } else if var textFieldViewController = textFieldViewInfo.textFieldView.iq.viewContainingController() {

            if textFieldViewInfo.textFieldView.iq.textFieldSearchBar() != nil,
               let navController: UINavigationController = textFieldViewController as? UINavigationController,
               let topController: UIViewController = navController.topViewController {
                textFieldViewController = topController
            }

            if !isEnabled, enabledDistanceHandlingClasses.contains(where: { textFieldViewController.isKind(of: $0) }) {
                isEnabled = true
            }

            if isEnabled {

                if disabledDistanceHandlingClasses.contains(where: { textFieldViewController.isKind(of: $0) }) {
                    isEnabled = false
                }

                if isEnabled {

                    let classNameString: String = "\(type(of: textFieldViewController.self))"

                    if classNameString.contains("UIAlertController"),
                       classNameString.hasSuffix("TextFieldViewController") {
                        isEnabled = false
                    }
                }
            }
        }

        return isEnabled
    }

    func privateIsEnableAutoToolbar() -> Bool {

        var isEnabled: Bool = enableAutoToolbar

        guard let textFieldViewInfo: IQTextFieldViewInfo = activeConfiguration.textFieldViewInfo,
              var textFieldViewController = textFieldViewInfo.textFieldView.iq.viewContainingController() else {
            return isEnabled
        }

        if textFieldViewInfo.textFieldView.iq.textFieldSearchBar() != nil,
           let navController: UINavigationController = textFieldViewController as? UINavigationController,
           let topController: UIViewController = navController.topViewController {
            textFieldViewController = topController
        }

        if !isEnabled, enabledToolbarClasses.contains(where: { textFieldViewController.isKind(of: $0) }) {
            isEnabled = true
        }

        if isEnabled {

            if disabledToolbarClasses.contains(where: { textFieldViewController.isKind(of: $0) }) {
                isEnabled = false
            }

            if isEnabled {

                let classNameString: String = "\(type(of: textFieldViewController.self))"

                if classNameString.contains("UIAlertController"), classNameString.hasSuffix("TextFieldViewController") {
                    isEnabled = false
                }
            }
        }

        return isEnabled
    }

    func privateResignOnTouchOutside() -> Bool {

        var isEnabled: Bool = resignOnTouchOutside

        guard let textFieldViewInfo: IQTextFieldViewInfo = activeConfiguration.textFieldViewInfo else {
            return isEnabled
        }

        let enableMode: IQEnableMode = textFieldViewInfo.textFieldView.iq.resignOnTouchOutsideMode

        if enableMode == .enabled {
            isEnabled = true
        } else if enableMode == .disabled {
            isEnabled = false
        } else if var textFieldViewController = textFieldViewInfo.textFieldView.iq.viewContainingController() {

            if textFieldViewInfo.textFieldView.iq.textFieldSearchBar() != nil,
               let navController: UINavigationController = textFieldViewController as? UINavigationController,
               let topController: UIViewController = navController.topViewController {
                textFieldViewController = topController
            }

            if !isEnabled,
               enabledTouchResignedClasses.contains(where: { textFieldViewController.isKind(of: $0) }) {
                isEnabled = true
            }

            if isEnabled {

                if disabledTouchResignedClasses.contains(where: { textFieldViewController.isKind(of: $0) }) {
                    isEnabled = false
                }

                if isEnabled {

                    let classNameString: String = "\(type(of: textFieldViewController.self))"

                    if classNameString.contains("UIAlertController"),
                        classNameString.hasSuffix("TextFieldViewController") {
                        isEnabled = false
                    }
                }
            }
        }
        return isEnabled
    }
}
