//
//  KKXArrowView.swift
//  KKXMobile
//
//  Created by ming on 2019/6/12.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit

@objc public enum KKXArrowDirection: Int {
    case up
    case down
    case left
    case right
}

@IBDesignable
public class KKXArrowView: UIView {
    
    // MARK: -------- Properties --------
    
    /// 箭头方向
    @IBInspectable public var direction: KKXArrowDirection = .right {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 箭头颜色
    @IBInspectable public var arrowColor: UIColor = defaultColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private static var defaultColor: UIColor {
        if #available(iOS 13.0, *) {
            return .separator
        } else {
            return UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 67.0/255.0, alpha: 0.3)
        }
    }
    
    // MARK: -------- Init --------
    
    convenience init() {
        self.init(direction: .right)
    }
    
    public init(direction: KKXArrowDirection) {
        super.init(frame:.zero)
        self.direction = direction
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }
    
    // MARK: -------- Configure --------
    
    private func configureSubviews() {
        backgroundColor = .clear
    }

    public override func draw(_ rect: CGRect) {
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        context?.fillPath()
        
        context?.setStrokeColor(arrowColor.cgColor)
        context?.setLineWidth(2.0)
        
        let centerX = rect.size.width/2
        let centerY = rect.size.height/2
        let w: CGFloat = 7.5
        
        var startPoint = CGPoint(x: centerX - w/2, y: centerY - w)
        var middlePoint = CGPoint(x: centerX + w/2, y: centerY)
        var endPoint = CGPoint(x: centerX - w/2, y: centerY + w)
        switch direction {
        case .up:
            startPoint = CGPoint(x: centerX - w, y: centerY + w/2)
            middlePoint = CGPoint(x: centerX, y: centerY - w/2)
            endPoint = CGPoint(x: centerX + w, y: centerY + w/2)
        case .down:
            startPoint = CGPoint(x: centerX - w, y: centerY - w/2)
            middlePoint = CGPoint(x: centerX, y: centerY + w/2)
            endPoint = CGPoint(x: centerX + w, y: centerY - w/2)
        case .left:
            startPoint = CGPoint(x: centerX + w/2, y: centerY - w)
            middlePoint = CGPoint(x: centerX - w/2, y: centerY)
            endPoint = CGPoint(x: centerX + w/2, y: centerY + w)
        case .right:
            startPoint = CGPoint(x: centerX - w/2, y: centerY - w)
            middlePoint = CGPoint(x: centerX + w/2, y: centerY)
            endPoint = CGPoint(x: centerX - w/2, y: centerY + w)
        }
        
        context?.addLines(between: [startPoint, middlePoint, endPoint])
        context?.strokePath()
    }
    
}
