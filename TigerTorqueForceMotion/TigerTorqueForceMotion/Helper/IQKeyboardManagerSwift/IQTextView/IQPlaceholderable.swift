
import Foundation
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
public protocol IQPlaceholderable: AnyObject {

    var placeholder: String? { get set }
    var attributedPlaceholder: NSAttributedString? { get set }
}

@available(iOSApplicationExtension, unavailable)
extension UITextField: IQPlaceholderable { }

@available(iOSApplicationExtension, unavailable)
extension IQTextView: IQPlaceholderable { }
