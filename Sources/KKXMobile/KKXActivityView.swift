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
    
    public var mode: KKXActivityMode = .default {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    public let label: UILabel = UILabel()

    // MARK: -------- Private Properties --------
    
    private let contentView: UIView = UIView()
    private let activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: -------- Init --------
    
    public class func show(in view: UIView) -> KKXActivityView {
        let activityView = KKXActivityView()
        activityView.frame = view.bounds
        view.addSubview(activityView)
        return activityView
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
        
        contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.style = .whiteLarge
        activityView.startAnimating()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        setNeedsUpdateConstraints()
    }
    
    // MARK: -------- Actions --------
    
    public func show(in view: UIView) {
        frame = view.bounds
        view.addSubview(self)
    }
    
    public func hide(_ afterDelay: TimeInterval = 1.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) {
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    // MARK: -------- Layout --------
    
    private let contentWidth: CGFloat = 80
    private let minContentMargin: CGFloat = 30
    private let innerMargin: CGFloat = 10
    public override func updateConstraints() {
        super.updateConstraints()
    
        contentView.removeConstraints(contentView.constraints)
        activityView.removeConstraints(activityView.constraints)
        label.removeConstraints(label.constraints)
        
        let hasText = (mode == .text)
        activityView.isHidden = hasText
        label.isHidden = !hasText
        
        if hasText {
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            for attr in [NSLayoutConstraint.Attribute.leading, NSLayoutConstraint.Attribute.top] {
                NSLayoutConstraint(
                    item: label,
                    attribute: attr,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: attr,
                    multiplier: 1.0,
                    constant: innerMargin
                ).isActive = true
            }
            for attr in [NSLayoutConstraint.Attribute.centerX, NSLayoutConstraint.Attribute.centerY] {
                NSLayoutConstraint(
                    item: label,
                    attribute: attr,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: attr,
                    multiplier: 1.0,
                    constant: 0
                ).isActive = true
                
                NSLayoutConstraint(
                    item: contentView,
                    attribute: attr,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: attr,
                    multiplier: 1.0,
                    constant: 0
                ).isActive = true
            }
            NSLayoutConstraint(
                item: contentView,
                attribute: .leading,
                relatedBy: .greaterThanOrEqual,
                toItem: self,
                attribute: .leading,
                multiplier: 1.0,
                constant: minContentMargin
            ).isActive = true
        } else {
            
            for attr in [NSLayoutConstraint.Attribute.width, NSLayoutConstraint.Attribute.height] {
                NSLayoutConstraint(
                    item: contentView,
                    attribute: attr,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1.0,
                    constant: contentWidth
                ).isActive = true
            }
            for attr in [NSLayoutConstraint.Attribute.centerX, NSLayoutConstraint.Attribute.centerY] {
                NSLayoutConstraint(
                    item: activityView,
                    attribute: attr,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: attr,
                    multiplier: 1.0,
                    constant: 0
                ).isActive = true
                
                NSLayoutConstraint(
                    item: contentView,
                    attribute: attr,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: attr,
                    multiplier: 1.0,
                    constant: 0
                ).isActive = true
            }
        }
    }
}
