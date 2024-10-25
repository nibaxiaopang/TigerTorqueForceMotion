
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc open class IQToolbar: UIToolbar, UIInputViewAudioFeedback {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    private func initialize() {

        sizeToFit()

        autoresizingMask = .flexibleWidth
        self.isTranslucent = true
        self.barTintColor = nil

        let positions: [UIBarPosition] = [.any, .bottom, .top, .topAttached]

        for position in positions {

            self.setBackgroundImage(nil, forToolbarPosition: position, barMetrics: .default)
            self.setShadowImage(nil, forToolbarPosition: .any)
        }

        self.backgroundColor = nil
    }

    open var additionalLeadingItems: [UIBarButtonItem] = []

    open var additionalTrailingItems: [UIBarButtonItem] = []

    private var privatePreviousBarButton: IQBarButtonItem?
    @objc open var previousBarButton: IQBarButtonItem {
        get {
            if privatePreviousBarButton == nil {
                privatePreviousBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
            }
            return privatePreviousBarButton!
        }

        set (newValue) {
            privatePreviousBarButton = newValue
        }
    }

    private var privateNextBarButton: IQBarButtonItem?
    @objc open var nextBarButton: IQBarButtonItem {
        get {
            if privateNextBarButton == nil {
                privateNextBarButton = IQBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
            }
            return privateNextBarButton!
        }

        set (newValue) {
            privateNextBarButton = newValue
        }
    }

    private var privateTitleBarButton: IQTitleBarButtonItem?
    @objc open var titleBarButton: IQTitleBarButtonItem {
        get {
            if privateTitleBarButton == nil {
                privateTitleBarButton = IQTitleBarButtonItem(title: nil)
                privateTitleBarButton?.accessibilityTraits = .staticText
                privateTitleBarButton?.accessibilityLabel = "Title"
                privateTitleBarButton?.accessibilityIdentifier = privateTitleBarButton?.accessibilityLabel
            }
            return privateTitleBarButton!
        }

        set (newValue) {
            privateTitleBarButton = newValue
        }
    }

    private var privateDoneBarButton: IQBarButtonItem?
    @objc open var doneBarButton: IQBarButtonItem {
        get {
            if privateDoneBarButton == nil {
                privateDoneBarButton = IQBarButtonItem(title: nil, style: .done, target: nil, action: nil)
            }
            return privateDoneBarButton!
        }

        set (newValue) {
            privateDoneBarButton = newValue
        }
    }

    private var privateFixedSpaceBarButton: IQBarButtonItem?
    @objc open var fixedSpaceBarButton: IQBarButtonItem {
        get {
            if privateFixedSpaceBarButton == nil {
                privateFixedSpaceBarButton = IQBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            }
            privateFixedSpaceBarButton?.isSystemItem = true
            privateFixedSpaceBarButton?.width = 6

            return privateFixedSpaceBarButton!
        }

        set (newValue) {
            privateFixedSpaceBarButton = newValue
        }
    }

    @objc override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFit: CGSize = super.sizeThatFits(size)
        sizeThatFit.height = 44
        return sizeThatFit
    }

    @objc override open var tintColor: UIColor! {

        didSet {
            if let unwrappedItems: [UIBarButtonItem] = items {
                for item in unwrappedItems {
                    item.tintColor = tintColor
                }
            }
        }
    }

    @objc open var enableInputClicksWhenVisible: Bool {
        return true
    }
}
