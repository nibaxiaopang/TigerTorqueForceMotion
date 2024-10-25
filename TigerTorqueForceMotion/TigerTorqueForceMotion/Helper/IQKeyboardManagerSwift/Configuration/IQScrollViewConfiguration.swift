
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
internal struct IQScrollViewConfiguration {
    let scrollView: UIScrollView
    let startingContentOffset: CGPoint
    let startingScrollIndicatorInsets: UIEdgeInsets
    let startingContentInset: UIEdgeInsets

    private let canRestoreContentOffset: Bool

    init(scrollView: UIScrollView, canRestoreContentOffset: Bool) {
        self.scrollView = scrollView
        self.canRestoreContentOffset = canRestoreContentOffset

        startingContentOffset = scrollView.contentOffset
        startingContentInset = scrollView.contentInset

#if swift(>=5.1)
        if #available(iOS 11.1, *) {
            startingScrollIndicatorInsets = scrollView.verticalScrollIndicatorInsets
        } else {
            startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
        }
#else
        startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
#endif
    }

    var hasChanged: Bool {
        if scrollView.contentInset != self.startingContentInset {
            return true
        }

        if canRestoreContentOffset,
           scrollView.iq.restoreContentOffset,
           !scrollView.contentOffset.equalTo(startingContentOffset) {
            return true
        }
        return false
    }

    @discardableResult
    func restore(for textFieldView: UIView?) -> Bool {
        var success: Bool = false

        if scrollView.contentInset != self.startingContentInset {
            scrollView.contentInset = self.startingContentInset
            scrollView.layoutIfNeeded() // (Bug ID: #1996)
            success = true
        }

#if swift(>=5.1)
        if #available(iOS 11.1, *) {
            if scrollView.verticalScrollIndicatorInsets != self.startingScrollIndicatorInsets {
                scrollView.verticalScrollIndicatorInsets = self.startingScrollIndicatorInsets
            }
        } else {
            if scrollView.scrollIndicatorInsets != self.startingScrollIndicatorInsets {
                scrollView.scrollIndicatorInsets = self.startingScrollIndicatorInsets
            }
        }
#else
        if scrollView.scrollIndicatorInsets != self.startingScrollIndicatorInsets {
            scrollView.scrollIndicatorInsets = self.startingScrollIndicatorInsets
        }
#endif

        if canRestoreContentOffset,
           scrollView.iq.restoreContentOffset,
           !scrollView.contentOffset.equalTo(startingContentOffset) {

            let stackView: UIStackView? = textFieldView?.iq.superviewOf(type: UIStackView.self,
                                                                        belowView: scrollView)

            let animatedContentOffset: Bool = stackView != nil ||
            scrollView is UICollectionView ||
            scrollView is UITableView

            if animatedContentOffset {
                scrollView.setContentOffset(startingContentOffset, animated: UIView.areAnimationsEnabled)
            } else {
                scrollView.contentOffset = startingContentOffset
            }
            success = true
        }

        return success
    }
}
