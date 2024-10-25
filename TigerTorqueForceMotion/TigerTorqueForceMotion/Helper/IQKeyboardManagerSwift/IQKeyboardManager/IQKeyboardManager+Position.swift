
import UIKit

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {

    @MainActor
    private struct AssociatedKeys {
        static var movedDistance: Int = 0
        static var movedDistanceChanged: Int = 0
        static var lastScrollViewConfiguration: Int = 0
        static var startingTextViewConfiguration: Int = 0
        static var activeConfiguration: Int = 0
    }

    private(set) var movedDistance: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.movedDistance) as? CGFloat ?? 0.0
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.movedDistance, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            movedDistanceChanged?(movedDistance)
        }
    }

    @objc var movedDistanceChanged: ((CGFloat) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.movedDistanceChanged) as? ((CGFloat) -> Void)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.movedDistanceChanged,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            movedDistanceChanged?(movedDistance)
        }
    }

    internal var lastScrollViewConfiguration: IQScrollViewConfiguration? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.lastScrollViewConfiguration) as? IQScrollViewConfiguration
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.lastScrollViewConfiguration,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal var startingTextViewConfiguration: IQScrollViewConfiguration? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedKeys.startingTextViewConfiguration) as? IQScrollViewConfiguration
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.startingTextViewConfiguration,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal func addActiveConfigurationObserver() {
        activeConfiguration.registerChange(identifier: UUID().uuidString, changeHandler: { event, _, _ in
            switch event {
            case .show:
                self.handleKeyboardTextFieldViewVisible()
            case .change:
                self.handleKeyboardTextFieldViewChanged()
            case .hide:
                self.handleKeyboardTextFieldViewHide()
            }
        })
    }

    @objc internal func applicationDidBecomeActive(_ notification: Notification) {

        guard privateIsEnabled(),
              activeConfiguration.keyboardInfo.keyboardShowing,
              activeConfiguration.isReady else {
            return
        }
        adjustPosition()
    }

    internal func adjustPosition() {

        guard UIApplication.shared.applicationState == .active,
              let textFieldView: UIView = activeConfiguration.textFieldViewInfo?.textFieldView,
              let superview: UIView = textFieldView.superview,
              let rootConfiguration = activeConfiguration.rootControllerConfiguration,
              let window: UIWindow = rootConfiguration.rootController.view.window else {
            return
        }

        showLog(">>>>> \(#function) started >>>>>", indentation: 1)
        let startTime: CFTimeInterval = CACurrentMediaTime()

        let rootController: UIViewController = rootConfiguration.rootController
        let textFieldViewRectInWindow: CGRect = superview.convert(textFieldView.frame, to: window)
        let textFieldViewRectInRootSuperview: CGRect = superview.convert(textFieldView.frame,
                                                                         to: rootController.view.superview)

        var rootViewOrigin: CGPoint = rootController.view.frame.origin

        let keyboardDistance: CGFloat

        do {

            let specialKeyboardDistanceFromTextField: CGFloat

            if let searchBar: UIView = textFieldView.iq.textFieldSearchBar() {
                specialKeyboardDistanceFromTextField = searchBar.iq.distanceFromKeyboard
            } else {
                specialKeyboardDistanceFromTextField = textFieldView.iq.distanceFromKeyboard
            }

            if specialKeyboardDistanceFromTextField == UIView.defaultKeyboardDistance {
                keyboardDistance = keyboardDistanceFromTextField
            } else {
                keyboardDistance = specialKeyboardDistanceFromTextField
            }
        }

        let kbSize: CGSize
        let originalKbSize: CGSize = activeConfiguration.keyboardInfo.frame.size

        do {
            var kbFrame: CGRect = activeConfiguration.keyboardInfo.frame

            kbFrame.origin.y -= keyboardDistance
            kbFrame.size.height += keyboardDistance

            kbFrame.origin.y -= rootConfiguration.beginSafeAreaInsets.bottom
            kbFrame.size.height += rootConfiguration.beginSafeAreaInsets.bottom

            let intersectRect: CGRect = kbFrame.intersection(window.frame)

            if intersectRect.isNull {
                kbSize = CGSize(width: kbFrame.size.width, height: 0)
            } else {
                kbSize = intersectRect.size
            }
        }

        let statusBarHeight: CGFloat

        let navigationBarAreaHeight: CGFloat
        if let navigationController: UINavigationController = rootController.navigationController {
            navigationBarAreaHeight = navigationController.navigationBar.frame.maxY
        } else {
#if swift(>=5.1)
            if #available(iOS 13, *) {
                statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
#else
            statusBarHeight = UIApplication.shared.statusBarFrame.height
#endif
            navigationBarAreaHeight = statusBarHeight
        }

        let isScrollableTextView: Bool

        if let textView: UIScrollView = textFieldView as? UIScrollView,
           textFieldView.responds(to: #selector(getter: UITextView.isEditable)) {
            isScrollableTextView = textView.isScrollEnabled
        } else {
            isScrollableTextView = false
        }

        let directionalLayoutMargin: NSDirectionalEdgeInsets = rootController.view.directionalLayoutMargins
        let topLayoutGuide: CGFloat = CGFloat.maximum(navigationBarAreaHeight, directionalLayoutMargin.top)

        let bottomLayoutGuide: CGFloat = isScrollableTextView ? 0 : directionalLayoutMargin.bottom

        var moveUp: CGFloat

        do {
            let visibleHeight: CGFloat = window.frame.height-kbSize.height

            let topMovement: CGFloat = textFieldViewRectInRootSuperview.minY-topLayoutGuide
            let bottomMovement: CGFloat = textFieldViewRectInWindow.maxY - visibleHeight + bottomLayoutGuide
            moveUp = CGFloat.minimum(topMovement, bottomMovement)
            moveUp = CGFloat(Int(moveUp))
        }

        showLog("Need to move: \(moveUp), will be moving \(moveUp < 0 ? "down" : "up")")

        var superScrollView: UIScrollView?
        var superView: UIScrollView? = textFieldView.iq.superviewOf(type: UIScrollView.self)

        while let view: UIScrollView = superView {

            if view.isScrollEnabled, !view.iq.ignoreScrollingAdjustment {
                superScrollView = view
                break
            } else {

                superView = view.iq.superviewOf(type: UIScrollView.self)
            }
        }

        if let lastConfiguration: IQScrollViewConfiguration = lastScrollViewConfiguration {

            if superScrollView == nil {

                if lastConfiguration.hasChanged {
                    if lastConfiguration.scrollView.contentInset != lastConfiguration.startingContentInset {
                        showLog("Restoring contentInset to: \(lastConfiguration.startingContentInset)")
                    }

                    if lastConfiguration.scrollView.iq.restoreContentOffset,
                       !lastConfiguration.scrollView.contentOffset.equalTo(lastConfiguration.startingContentOffset) {
                        showLog("Restoring contentOffset to: \(lastConfiguration.startingContentOffset)")
                    }

                    activeConfiguration.animate(alongsideTransition: {
                        lastConfiguration.restore(for: textFieldView)
                    })
                }

                self.lastScrollViewConfiguration = nil
            } else if superScrollView != lastConfiguration.scrollView {

                if lastConfiguration.hasChanged {
                    if lastConfiguration.scrollView.contentInset != lastConfiguration.startingContentInset {
                        showLog("Restoring contentInset to: \(lastConfiguration.startingContentInset)")
                    }

                    if lastConfiguration.scrollView.iq.restoreContentOffset,
                       !lastConfiguration.scrollView.contentOffset.equalTo(lastConfiguration.startingContentOffset) {
                        showLog("Restoring contentOffset to: \(lastConfiguration.startingContentOffset)")
                    }

                    activeConfiguration.animate(alongsideTransition: {
                        lastConfiguration.restore(for: textFieldView)
                    })
                }

                if let superScrollView = superScrollView {
                    let configuration = IQScrollViewConfiguration(scrollView: superScrollView,
                                                                  canRestoreContentOffset: true)
                    self.lastScrollViewConfiguration = configuration
                    showLog("""
                            Saving ScrollView New contentInset: \(configuration.startingContentInset)
                            and contentOffset: \(configuration.startingContentOffset)
                            """)
                } else {
                    self.lastScrollViewConfiguration = nil
                }
            }

        } else if let superScrollView: UIScrollView = superScrollView {

            let configuration = IQScrollViewConfiguration(scrollView: superScrollView, canRestoreContentOffset: true)
            self.lastScrollViewConfiguration = configuration
            showLog("""
                    Saving ScrollView New contentInset: \(configuration.startingContentInset)
                    and contentOffset: \(configuration.startingContentOffset)
                    """)
        }

        if let lastScrollViewConfiguration: IQScrollViewConfiguration  = lastScrollViewConfiguration {

            var lastView: UIView = textFieldView
            var superScrollView: UIScrollView? = lastScrollViewConfiguration.scrollView

            while let scrollView: UIScrollView = superScrollView {

                var isContinue: Bool = false

                if moveUp > 0 {
                    isContinue = moveUp > (-scrollView.contentOffset.y - scrollView.contentInset.top)

                } else if let tableView: UITableView = scrollView.iq.superviewOf(type: UITableView.self) {

                    isContinue = scrollView.contentOffset.y > 0

                    if isContinue,
                       let tableCell: UITableViewCell = textFieldView.iq.superviewOf(type: UITableViewCell.self),
                       let indexPath: IndexPath = tableView.indexPath(for: tableCell),
                       let previousIndexPath: IndexPath = tableView.previousIndexPath(of: indexPath) {

                        let previousCellRect: CGRect = tableView.rectForRow(at: previousIndexPath)
                        if !previousCellRect.isEmpty {
                            let superview: UIView? = rootController.view.superview
                            let previousCellRectInRootSuperview: CGRect = tableView.convert(previousCellRect,
                                                                                            to: superview)

                            moveUp = CGFloat.minimum(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                        }
                    }
                } else if let collectionView = scrollView.iq.superviewOf(type: UICollectionView.self) {

                    isContinue = scrollView.contentOffset.y > 0

                    if isContinue,
                       let collectionCell = textFieldView.iq.superviewOf(type: UICollectionViewCell.self),
                       let indexPath: IndexPath = collectionView.indexPath(for: collectionCell),
                       let previousIndexPath: IndexPath = collectionView.previousIndexPath(of: indexPath),
                       let attributes = collectionView.layoutAttributesForItem(at: previousIndexPath) {

                        let previousCellRect: CGRect = attributes.frame
                        if !previousCellRect.isEmpty {
                            let superview: UIView? = rootController.view.superview
                            let previousCellRectInRootSuperview: CGRect = collectionView.convert(previousCellRect,
                                                                                                 to: superview)

                            moveUp = CGFloat.minimum(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                        }
                    }
                } else {
                    isContinue = textFieldViewRectInRootSuperview.minY < topLayoutGuide

                    if isContinue {
                        moveUp = CGFloat.minimum(0, textFieldViewRectInRootSuperview.minY - topLayoutGuide)
                    }
                }

                if isContinue {

                    var tempScrollView: UIScrollView? = scrollView.iq.superviewOf(type: UIScrollView.self)
                    var nextScrollView: UIScrollView?
                    while let view: UIScrollView = tempScrollView {

                        if view.isScrollEnabled, !view.iq.ignoreScrollingAdjustment {
                            nextScrollView = view
                            break
                        } else {
                            tempScrollView = view.iq.superviewOf(type: UIScrollView.self)
                        }
                    }

                    if let lastViewRect: CGRect = lastView.superview?.convert(lastView.frame, to: scrollView) {

                        let minimumMovement: CGFloat = CGFloat.minimum(scrollView.contentOffset.y, -moveUp)
                        var suggestedOffsetY: CGFloat = scrollView.contentOffset.y - minimumMovement

                        suggestedOffsetY = CGFloat.minimum(suggestedOffsetY, lastViewRect.minY)

                        if isScrollableTextView,
                            nextScrollView == nil,
                            suggestedOffsetY >= 0 {

                            if let superview: UIView = textFieldView.superview {

                                let currentTextFieldViewRect: CGRect = superview.convert(textFieldView.frame,
                                                                                         to: window)

                                let expectedFixDistance: CGFloat = currentTextFieldViewRect.minY - topLayoutGuide

                                let expectedOffsetY: CGFloat = scrollView.contentOffset.y + expectedFixDistance
                                suggestedOffsetY = CGFloat.minimum(suggestedOffsetY, expectedOffsetY)

                                moveUp = 0
                            } else {
                               
                                moveUp -= (suggestedOffsetY-scrollView.contentOffset.y)
                            }
                        } else {
                           
                            moveUp -= (suggestedOffsetY-scrollView.contentOffset.y)
                        }

                        let newContentOffset: CGPoint = CGPoint(x: scrollView.contentOffset.x, y: suggestedOffsetY)

                        if !scrollView.contentOffset.equalTo(newContentOffset) {

                            showLog("""
                                    old contentOffset: \(scrollView.contentOffset)
                                    new contentOffset: \(newContentOffset)
                                    """)
                            self.showLog("Remaining Move: \(moveUp)")

                            activeConfiguration.animate(alongsideTransition: {

                                let stackView: UIStackView? = textFieldView.iq.superviewOf(type: UIStackView.self,
                                                                                           belowView: scrollView)

                                let animatedContentOffset: Bool = stackView != nil ||
                                scrollView is UICollectionView ||
                                scrollView is UITableView

                                if animatedContentOffset {
                                    scrollView.setContentOffset(newContentOffset, animated: UIView.areAnimationsEnabled)
                                } else {
                                    scrollView.contentOffset = newContentOffset
                                }
                            }, completion: {

                                if scrollView is UITableView || scrollView is UICollectionView {

                                    self.reloadInputViews()
                                }
                            })
                        }
                    }

                    lastView = scrollView
                    superScrollView = nextScrollView
                } else {
                    moveUp = 0
                    break
                }
            }

            let lastScrollView = lastScrollViewConfiguration.scrollView
            if let lastScrollViewRect: CGRect = lastScrollView.superview?.convert(lastScrollView.frame, to: window),
                !lastScrollView.iq.ignoreContentInsetAdjustment {

                var bottomInset: CGFloat = (kbSize.height)-(window.frame.height-lastScrollViewRect.maxY)
                let keyboardAndSafeArea: CGFloat = keyboardDistance + rootConfiguration.beginSafeAreaInsets.bottom
                var bottomScrollIndicatorInset: CGFloat = bottomInset - keyboardAndSafeArea

                bottomInset = CGFloat.maximum(lastScrollViewConfiguration.startingContentInset.bottom, bottomInset)
                let startingScrollInset: UIEdgeInsets = lastScrollViewConfiguration.startingScrollIndicatorInsets
                bottomScrollIndicatorInset = CGFloat.maximum(startingScrollInset.bottom,
                                                             bottomScrollIndicatorInset)

                bottomInset -= lastScrollView.safeAreaInsets.bottom
                bottomScrollIndicatorInset -= lastScrollView.safeAreaInsets.bottom

                var movedInsets: UIEdgeInsets = lastScrollView.contentInset
                movedInsets.bottom = bottomInset

                if lastScrollView.contentInset != movedInsets {
                    showLog("old ContentInset: \(lastScrollView.contentInset) new ContentInset: \(movedInsets)")

                    activeConfiguration.animate(alongsideTransition: {
                        lastScrollView.contentInset = movedInsets
                        lastScrollView.layoutIfNeeded()

                        var newScrollIndicatorInset: UIEdgeInsets

                        #if swift(>=5.1)
                        if #available(iOS 11.1, *) {
                            newScrollIndicatorInset = lastScrollView.verticalScrollIndicatorInsets
                        } else {
                            newScrollIndicatorInset = lastScrollView.scrollIndicatorInsets
                        }
                        #else
                        newScrollIndicatorInset = lastScrollView.scrollIndicatorInsets
                        #endif

                        newScrollIndicatorInset.bottom = bottomScrollIndicatorInset
                        lastScrollView.scrollIndicatorInsets = newScrollIndicatorInset
                    })
                }
            }
        }

        if isScrollableTextView, let textView = textFieldView as? UIScrollView {

            let keyboardYPosition: CGFloat = window.frame.height - originalKbSize.height
            var rootSuperViewFrameInWindow: CGRect = window.frame
            if let rootSuperview: UIView = rootController.view.superview {
                rootSuperViewFrameInWindow = rootSuperview.convert(rootSuperview.bounds, to: window)
            }

            let keyboardOverlapping: CGFloat = rootSuperViewFrameInWindow.maxY - keyboardYPosition

            let availableHeight: CGFloat = rootSuperViewFrameInWindow.height-topLayoutGuide-keyboardOverlapping
            let textViewHeight: CGFloat = CGFloat.minimum(textView.frame.height, availableHeight)

            if textView.frame.size.height-textView.contentInset.bottom>textViewHeight {

                if startingTextViewConfiguration == nil {
                    startingTextViewConfiguration = IQScrollViewConfiguration(scrollView: textView,
                                                                              canRestoreContentOffset: false)
                }

                var newContentInset: UIEdgeInsets = textView.contentInset
                newContentInset.bottom = textView.frame.size.height-textViewHeight
                newContentInset.bottom -= textView.safeAreaInsets.bottom

                if textView.contentInset != newContentInset {
                    self.showLog("""
                                \(textFieldView) Old UITextView.contentInset: \(textView.contentInset)
                                 New UITextView.contentInset: \(newContentInset)
                                """)

                    activeConfiguration.animate(alongsideTransition: {

                        textView.contentInset = newContentInset
                        textView.layoutIfNeeded()
                        textView.scrollIndicatorInsets = newContentInset
                    })
                }
            }
        }

        if moveUp >= 0 {

            rootViewOrigin.y = CGFloat.maximum(rootViewOrigin.y - moveUp, CGFloat.minimum(0, -originalKbSize.height))

            if !rootController.view.frame.origin.equalTo(rootViewOrigin) {
                showLog("Moving Upward")

                activeConfiguration.animate(alongsideTransition: {

                    var rect: CGRect = rootController.view.frame
                    rect.origin = rootViewOrigin
                    rootController.view.frame = rect

                    if self.layoutIfNeededOnUpdate {

                        rootController.view.setNeedsLayout()
                        rootController.view.layoutIfNeeded()
                    }

                    let classNameString: String = "\(type(of: rootController.self))"
                    self.showLog("Set \(classNameString) origin to: \(rootViewOrigin)")
                })
            }

            movedDistance = (rootConfiguration.beginOrigin.y-rootViewOrigin.y)
        } else {
            let disturbDistance: CGFloat = rootViewOrigin.y-rootConfiguration.beginOrigin.y

            if disturbDistance <= 0 {

                rootViewOrigin.y -= CGFloat.maximum(moveUp, disturbDistance)

                if !rootController.view.frame.origin.equalTo(rootViewOrigin) {
                    showLog("Moving Downward")

                    activeConfiguration.animate(alongsideTransition: {

                        var rect: CGRect = rootController.view.frame
                        rect.origin = rootViewOrigin
                        rootController.view.frame = rect

                        if self.layoutIfNeededOnUpdate {

                            rootController.view.setNeedsLayout()
                            rootController.view.layoutIfNeeded()
                        }

                        let classNameString: String = "\(type(of: rootController.self))"
                        self.showLog("Set \(classNameString) origin to: \(rootViewOrigin)")
                    })
                }

                movedDistance = (rootConfiguration.beginOrigin.y-rootViewOrigin.y)
            }
        }

        let elapsedTime: CFTimeInterval = CACurrentMediaTime() - startTime
        showLog("<<<<< \(#function) ended: \(elapsedTime) seconds <<<<<", indentation: -1)
    }
    
    internal func restorePosition() {

        guard let configuration: IQRootControllerConfiguration = activeConfiguration.rootControllerConfiguration else {
            return
        }
        let startTime: CFTimeInterval = CACurrentMediaTime()
        showLog(">>>>> \(#function) started >>>>>", indentation: 1)

        activeConfiguration.animate(alongsideTransition: {
            if configuration.hasChanged {
                let classNameString: String = "\(type(of: configuration.rootController.self))"
                self.showLog("Restoring \(classNameString) origin to: \(configuration.beginOrigin)")
            }
            configuration.restore()

            if self.layoutIfNeededOnUpdate {

                configuration.rootController.view.setNeedsLayout()
                configuration.rootController.view.layoutIfNeeded()
            }
        })

        if let textFieldView: UIView = activeConfiguration.textFieldViewInfo?.textFieldView,
           let lastConfiguration: IQScrollViewConfiguration = lastScrollViewConfiguration {

            activeConfiguration.animate(alongsideTransition: {

                if lastConfiguration.hasChanged {
                    if lastConfiguration.scrollView.contentInset != lastConfiguration.startingContentInset {
                        self.showLog("Restoring contentInset to: \(lastConfiguration.startingContentInset)")
                    }

                    if lastConfiguration.scrollView.iq.restoreContentOffset,
                       !lastConfiguration.scrollView.contentOffset.equalTo(lastConfiguration.startingContentOffset) {
                        self.showLog("Restoring contentOffset to: \(lastConfiguration.startingContentOffset)")
                    }

                    lastConfiguration.restore(for: textFieldView)
                }

                var superScrollView: UIScrollView? = lastConfiguration.scrollView

                while let scrollView: UIScrollView = superScrollView {

                    let width: CGFloat = CGFloat.maximum(scrollView.contentSize.width, scrollView.frame.width)
                    let height: CGFloat = CGFloat.maximum(scrollView.contentSize.height, scrollView.frame.height)
                    let contentSize: CGSize = CGSize(width: width, height: height)

                    let minimumY: CGFloat = contentSize.height - scrollView.frame.height

                    if minimumY < scrollView.contentOffset.y {

                        let newContentOffset: CGPoint = CGPoint(x: scrollView.contentOffset.x, y: minimumY)
                        if !scrollView.contentOffset.equalTo(newContentOffset) {

                            let stackView: UIStackView? = textFieldView.iq.superviewOf(type: UIStackView.self,
                                                                                       belowView: scrollView)

                            let animatedContentOffset: Bool = stackView != nil ||
                            scrollView is UICollectionView ||
                            scrollView is UITableView

                            if animatedContentOffset {
                                scrollView.setContentOffset(newContentOffset, animated: UIView.areAnimationsEnabled)
                            } else {
                                scrollView.contentOffset = newContentOffset
                            }

                            self.showLog("Restoring contentOffset to: \(newContentOffset)")
                        }
                    }

                    superScrollView = scrollView.iq.superviewOf(type: UIScrollView.self)
                }
            })
        }

        self.movedDistance = 0
        let elapsedTime: CFTimeInterval = CACurrentMediaTime() - startTime
        showLog("<<<<< \(#function) ended: \(elapsedTime) seconds <<<<<", indentation: -1)
    }

}
