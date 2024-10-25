
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
internal final class IQActiveConfiguration {

    private let keyboardListener: IQKeyboardListener = IQKeyboardListener()
    private let textFieldViewListener: IQTextFieldViewListener = IQTextFieldViewListener()

    private var changeObservers: [AnyHashable: ConfigurationCompletion] = [:]

    @objc public enum Event: Int {
        case hide
        case show
        case change

        var name: String {
            switch self {
            case .hide:
                return "hide"
            case .show:
                return "show"
            case .change:
                return "change"
            }
        }
    }

    private var lastEvent: Event = .hide

    var rootControllerConfiguration: IQRootControllerConfiguration?

    var isReady: Bool {
        if textFieldViewInfo != nil,
           let rootControllerConfiguration = rootControllerConfiguration {
            return rootControllerConfiguration.isReady
        }
        return false
    }

    init() {
        addKeyboardListener()
        addTextFieldViewListener()
    }

    private func sendEvent() {

        if let textFieldViewInfo = textFieldViewInfo,
           let rootControllerConfiguration = rootControllerConfiguration,
           rootControllerConfiguration.isReady {
            if keyboardInfo.keyboardShowing {
                if lastEvent == .hide {
                    self.notify(event: .show, keyboardInfo: keyboardInfo, textFieldViewInfo: textFieldViewInfo)
                } else {
                    self.notify(event: .change, keyboardInfo: keyboardInfo, textFieldViewInfo: textFieldViewInfo)
                }
            } else if lastEvent != .hide {
                if rootControllerConfiguration.beginOrientation == rootControllerConfiguration.currentOrientation {
                    self.notify(event: .hide, keyboardInfo: keyboardInfo, textFieldViewInfo: textFieldViewInfo)
                    self.rootControllerConfiguration = nil
                } else if rootControllerConfiguration.hasChanged {
                    animate(alongsideTransition: {
                        rootControllerConfiguration.restore()
                    }, completion: nil)
                }
            }
        }
    }

    private func updateRootController(info: IQTextFieldViewInfo?) {

        guard let info = info,
              let controller: UIViewController = info.textFieldView.iq.parentContainerViewController() else {
            if let rootControllerConfiguration = rootControllerConfiguration,
               rootControllerConfiguration.hasChanged {
                animate(alongsideTransition: {
                    rootControllerConfiguration.restore()
                }, completion: nil)
            }
            rootControllerConfiguration = nil
            return
        }

        let newConfiguration = IQRootControllerConfiguration(rootController: controller)

        if newConfiguration.rootController.view.window != rootControllerConfiguration?.rootController.view.window ||
            newConfiguration.beginOrientation != rootControllerConfiguration?.beginOrientation {

            if rootControllerConfiguration?.rootController != newConfiguration.rootController {

                if let rootControllerConfiguration = rootControllerConfiguration,
                   rootControllerConfiguration.hasChanged {
                    animate(alongsideTransition: {
                        rootControllerConfiguration.restore()
                    }, completion: nil)
                }
            }

            rootControllerConfiguration = newConfiguration
        }
    }
}

@available(iOSApplicationExtension, unavailable)
extension IQActiveConfiguration {

    var keyboardInfo: IQKeyboardInfo {
        return keyboardListener.keyboardInfo
    }

    private func addKeyboardListener() {
        keyboardListener.registerSizeChange(identifier: "IQActiveConfiguration", changeHandler: { [self] name, _ in

            if let info = textFieldViewInfo, keyboardInfo.keyboardShowing {
                if let rootControllerConfiguration = rootControllerConfiguration {
                    let beginIsPortrait: Bool = rootControllerConfiguration.beginOrientation.isPortrait
                    let currentIsPortrait: Bool = rootControllerConfiguration.currentOrientation.isPortrait
                    if beginIsPortrait != currentIsPortrait {
                        updateRootController(info: info)
                    }
                } else {
                    updateRootController(info: info)
                }
            }

            self.sendEvent()

            if name == .didHide {
                updateRootController(info: nil)
            }
        })
    }

    public func animate(alongsideTransition transition: @escaping () -> Void, completion: (() -> Void)? = nil) {
        keyboardListener.animate(alongsideTransition: transition, completion: completion)
    }
}

@available(iOSApplicationExtension, unavailable)
extension IQActiveConfiguration {

    var textFieldViewInfo: IQTextFieldViewInfo? {
        return textFieldViewListener.textFieldViewInfo
    }

    private func addTextFieldViewListener() {
        textFieldViewListener.registerTextFieldViewChange(identifier: "IQActiveConfiguration",
                                                          changeHandler: { [self] info in
            if info.name == .beginEditing {
                updateRootController(info: info)
                self.sendEvent()
            }
        })
    }
}

@available(iOSApplicationExtension, unavailable)
extension IQActiveConfiguration {

    typealias ConfigurationCompletion = (_ event: Event,
                                         _ keyboardInfo: IQKeyboardInfo,
                                         _ textFieldInfo: IQTextFieldViewInfo) -> Void

    func registerChange(identifier: AnyHashable, changeHandler: @escaping ConfigurationCompletion) {
        changeObservers[identifier] = changeHandler
    }

    func unregisterChange(identifier: AnyHashable) {
        changeObservers[identifier] = nil
    }

    private func notify(event: Event, keyboardInfo: IQKeyboardInfo, textFieldViewInfo: IQTextFieldViewInfo) {
        lastEvent = event

        for block in changeObservers.values {
            block(event, keyboardInfo, textFieldViewInfo)
        }
    }
}
