
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
internal struct IQRootControllerConfiguration {

    let rootController: UIViewController
    let beginOrigin: CGPoint
    let beginSafeAreaInsets: UIEdgeInsets
    let beginOrientation: UIInterfaceOrientation

    init(rootController: UIViewController) {
        self.rootController = rootController
        beginOrigin = rootController.view.frame.origin
        beginSafeAreaInsets = rootController.view.safeAreaInsets

        let interfaceOrientation: UIInterfaceOrientation
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            if let scene = rootController.view.window?.windowScene {
                interfaceOrientation = scene.interfaceOrientation
            } else {
                interfaceOrientation = .unknown
            }
        } else {
            interfaceOrientation = UIApplication.shared.statusBarOrientation
        }
        #else
        interfaceOrientation = UIApplication.shared.statusBarOrientation
        #endif

        beginOrientation = interfaceOrientation
    }

    var currentOrientation: UIInterfaceOrientation {
        let interfaceOrientation: UIInterfaceOrientation
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            if let scene = rootController.view.window?.windowScene {
                interfaceOrientation = scene.interfaceOrientation
            } else {
                interfaceOrientation = .unknown
            }
        } else {
            interfaceOrientation = UIApplication.shared.statusBarOrientation
        }
        #else
        interfaceOrientation = UIApplication.shared.statusBarOrientation
        #endif
        return interfaceOrientation
    }

    var isReady: Bool {
        return rootController.view.window != nil
    }

    var hasChanged: Bool {
        return !rootController.view.frame.origin.equalTo(beginOrigin)
    }

    @discardableResult
    func restore() -> Bool {
        if !rootController.view.frame.origin.equalTo(beginOrigin) {

            var rect: CGRect = rootController.view.frame
            rect.origin = beginOrigin
            rootController.view.frame = rect
            return true
        }
        return false
    }
}
