//
//  KKXActivityView.swift
//  SwiftMobile
//
//  Created by ming on 2020/1/7.
//  Copyright © 2020 ming. All rights reserved.
//

import UIKit

public enum KKXActivityMode {
    case `default`
    case text
}
public class KKXActivityView: UIView {

    // MARK: -------- Properties --------
    
    public var text: String = "" {
        didSet {
            label.text = text
            setNeedsLayout()
        }
    }
    public var mode: KKXActivityMode = .default {
        didSet {
            if mode == .default {
                activityView.startAnimating()
            }
            setNeedsLayout()
        }
    }
    public let removeFromSuperViewOnHide: Bool = false
    public lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    // MARK: -------- Private Properties --------
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        return contentView
    }()
    
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .whiteLarge
        return activityView
    }()
    
    // MARK: -------- Init --------
    
    public class func show(in view: UIView) -> KKXActivityView {
        let activityView = KKXActivityView()
        activityView.frame = view.bounds
        view.addSubview(activityView)
        activityView.show()
        return activityView
    }
    
    public convenience init(in view: UIView) {
        self.init(frame: view.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.configureSubviews()
    }
    
    // MARK: -------- Configure --------
    
    private func configureSubviews() {
        addSubview(contentView)
        contentView.addSubview(activityView)
        contentView.addSubview(label)
        activityView.startAnimating()
        alpha = 0
    }
    
    // MARK: -------- Actions --------
    
    public func show() {
        alpha = 1
        contentView.alpha = 1
    }
    
    public func hide(_ afterDelay: TimeInterval = 1.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) {
            self.alpha = 0
            self.contentView.alpha = 0
            if self.removeFromSuperViewOnHide {
                self.removeFromSuperview()
            }
        }
    }
    
    // MARK: -------- Layout --------
    
    private let contentWidth: CGFloat = 80
    private let minContentMargin: CGFloat = 30
    private let innerMargin: CGFloat = 10
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let maxContentWidth = frame.size.width - minContentMargin*2
        let maxContentHeight = frame.size.height - minContentMargin*2
        label.frame.size.width = maxContentWidth - innerMargin*2
        label.sizeToFit()
        
        if mode == .default {
            activityView.isHidden = false
            activityView.sizeToFit()
            
            let originY: CGFloat = 20
            let labelMaxH = maxContentHeight - originY - activityView.frame.size.height - innerMargin*2
            let contentW = max(activityView.frame.size.width + originY*2, label.frame.size.width + innerMargin*2)
            let originX = (contentW - activityView.frame.size.width)/2
            activityView.frame.origin = CGPoint(x: originX, y: originY)
            
            let labelX = (contentW - label.frame.size.width)/2
            let labelY = activityView.frame.maxY + innerMargin
            label.frame.origin = CGPoint(x: labelX, y: labelY)
            
            if label.frame.size.height > labelMaxH {
                label.frame.size.height = labelMaxH
            }
            
            let contentViewW = contentW
            let contentViewH = label.frame.maxY + innerMargin
            let contentViewX = (frame.size.width - contentViewW)/2
            let contentViewY = (frame.size.height - contentViewH)/2
            contentView.frame = CGRect(x: contentViewX, y: contentViewY, width: contentViewW, height: contentViewH)
        } else if mode == .text {
            activityView.isHidden = true
            let labelMaxH = maxContentHeight - innerMargin*2
            if label.frame.size.height > labelMaxH {
                label.frame.size.height = labelMaxH
            }
            
            let contentViewW = label.frame.size.width + innerMargin*2
            let contentViewH = label.frame.size.height + innerMargin*2
            let contentViewX = (frame.size.width - contentViewW)/2
            let contentViewY = (frame.size.height - contentViewH)/2
            contentView.frame = CGRect(x: contentViewX, y: contentViewY, width: contentViewW, height: contentViewH)
            label.center = CGPoint(x: contentViewW/2, y: contentViewH/2)
        }
    }
}
