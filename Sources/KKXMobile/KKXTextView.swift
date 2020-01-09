//
//  KKXTextView.swift
//  KKXMobile
//
//  Created by ming on 2019/6/25.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit

open class KKXTextView: UITextView {
    
    // MARK: -------- Properties --------
    
    public var textDidChanged:((String) -> Void)?
    
    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
        }
    }
    
    public var placeholderLabel: UILabel = UILabel()
    
    open override var font: UIFont? {
        get {
            return super.font
        }
        set {
            super.font = newValue
            placeholderLabel.font = newValue
            
        }
    }
    
    private var kkxPlaceholderText: UIColor {
        if #available(iOS 13.0, *) {
            return .placeholderText
        } else {
            return UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 67.0/255.0, alpha: 0.3)
        }
    }
    
    // MARK: -------- Init --------
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        removeObserver(self, forKeyPath: #keyPath(text), context: nil)
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configurations()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        configurations()
    }
    
    // MARK: -------- Helper --------
    
    private func configurations() {
        
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = kkxPlaceholderText
        placeholderLabel.font = font
        addSubview(placeholderLabel)
        
        textContainerInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        textContainer.lineFragmentPadding = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged(_:)), name: UITextView.textDidChangeNotification, object: nil)
        addObserver(self, forKeyPath: #keyPath(text), options: .new, context: nil)
    }
    
    // MARK: -------- Actions --------
    
    @objc private func textDidChanged(_ send: Notification) {
        if let textView = send.object as? UITextView, textView == self {
            placeholderLabel.isHidden = !text.isEmpty
            textDidChanged?(textView.text)
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case #keyPath(text):
            placeholderLabel.isHidden = !text.isEmpty
            textDidChanged?(text)
        default:
            break
        }
    }
    
    // MARK: -------- Layout --------
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let left: CGFloat = textContainerInset.left
        placeholderLabel.frame.size.width = frame.size.width - left * 2
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: left, y: textContainerInset.top)
    }
    
}
