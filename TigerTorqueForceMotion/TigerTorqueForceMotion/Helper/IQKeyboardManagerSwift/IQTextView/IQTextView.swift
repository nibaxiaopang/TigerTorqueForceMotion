
import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc open class IQTextView: UITextView {

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder),
                                               name: UITextView.textDidChangeNotification, object: self)
    }

    @objc override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder),
                                               name: UITextView.textDidChangeNotification, object: self)
    }

    @objc override open func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder),
                                               name: UITextView.textDidChangeNotification, object: self)
    }

    private var placeholderInsets: UIEdgeInsets {
        let top: CGFloat = self.textContainerInset.top
        let left: CGFloat = self.textContainerInset.left + self.textContainer.lineFragmentPadding
        let bottom: CGFloat = self.textContainerInset.bottom
        let right: CGFloat = self.textContainerInset.right + self.textContainer.lineFragmentPadding
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    private var placeholderExpectedFrame: CGRect {
        let insets: UIEdgeInsets = self.placeholderInsets
        let maxWidth: CGFloat = self.frame.width-insets.left-insets.right
        let size: CGSize = CGSize(width: maxWidth, height: self.frame.height-insets.top-insets.bottom)
        let expectedSize: CGSize = placeholderLabel.sizeThatFits(size)

        return CGRect(x: insets.left, y: insets.top, width: maxWidth, height: expectedSize.height)
    }

    lazy var placeholderLabel: UILabel = {
        let label = UILabel()

        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = self.font
        label.textAlignment = self.textAlignment
        label.backgroundColor = UIColor.clear
        label.isAccessibilityElement = false
        #if swift(>=5.1)
        label.textColor = UIColor.systemGray
        #else
        label.textColor = UIColor.lightText
        #endif
        label.alpha = 0
        self.addSubview(label)

        return label
    }()

    @IBInspectable open var placeholderTextColor: UIColor? {

        get {
            return placeholderLabel.textColor
        }

        set {
            placeholderLabel.textColor = newValue
        }
    }

    @IBInspectable open var placeholder: String? {

        get {
            return placeholderLabel.text
        }

        set {
            placeholderLabel.text = newValue
            refreshPlaceholder()
        }
    }

    open var attributedPlaceholder: NSAttributedString? {
        get {
            return placeholderLabel.attributedText
        }

        set {
            placeholderLabel.attributedText = newValue
            refreshPlaceholder()
        }
    }

    @objc override open func layoutSubviews() {
        super.layoutSubviews()

        placeholderLabel.frame = placeholderExpectedFrame
    }

    @objc private func refreshPlaceholder() {

        let text: String = text ?? attributedText?.string ?? ""
        if text.isEmpty {
            placeholderLabel.alpha = 1
        } else {
            placeholderLabel.alpha = 0
        }
    }

    @objc override open var text: String! {

        didSet {
            refreshPlaceholder()
        }
    }

    open override var attributedText: NSAttributedString! {

        didSet {
            refreshPlaceholder()
        }
    }

    @objc override open var font: UIFont? {

        didSet {

            if let unwrappedFont: UIFont = font {
                placeholderLabel.font = unwrappedFont
            } else {
                placeholderLabel.font = UIFont.systemFont(ofSize: 12)
            }
        }
    }

    @objc override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    @objc override weak open var delegate: UITextViewDelegate? {

        get {
            refreshPlaceholder()
            return super.delegate
        }

        set {
            super.delegate = newValue
        }
    }

    @objc override open var intrinsicContentSize: CGSize {
        guard !hasText else {
            return super.intrinsicContentSize
        }

        var newSize: CGSize = super.intrinsicContentSize
        let placeholderInsets: UIEdgeInsets = self.placeholderInsets
        newSize.height = placeholderExpectedFrame.height + placeholderInsets.top + placeholderInsets.bottom

        return newSize
    }
}
