//
//  KKXMaskCornerView.swift
//  KKXMobile
//
//  Created by ming on 2019/12/11.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit

public struct KKXCornerMask : OptionSet {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var none: KKXCornerMask = KKXCornerMask(rawValue: 0)
    public static var layerMinXMinYCorner: KKXCornerMask = KKXCornerMask(rawValue: 1 << 0)
    public static var layerMaxXMinYCorner: KKXCornerMask = KKXCornerMask(rawValue: 1 << 1)
    public static var layerMinXMaxYCorner: KKXCornerMask = KKXCornerMask(rawValue: 1 << 2)
    public static var layerMaxXMaxYCorner: KKXCornerMask = KKXCornerMask(rawValue: 1 << 3)
    public static let all: KKXCornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
}

public class KKXMaskCornerView: UIView {

    public override class var layerClass: AnyClass {
        CAShapeLayer.self
    }
    
    public var shapeLayer: CAShapeLayer {
        layer as! CAShapeLayer
    }
    
    public var fillColor: UIColor? = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var strokeColor: UIColor? = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var strokeWidth: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var maskedCorners: KKXCornerMask = .none {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var minXMinYCenter: CGPoint = .zero
    private var maxXMinYCenter: CGPoint = .zero
    private var minXMaxYCenter: CGPoint = .zero
    private var maxXMaxYCenter: CGPoint = .zero
    
    private let path = UIBezierPath()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        context?.fillPath()
        
        minXMinYCenter = CGPoint(x: cornerRadius, y: cornerRadius)
        maxXMinYCenter = CGPoint(x: frame.size.width - cornerRadius, y: cornerRadius)
        maxXMaxYCenter = CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height - cornerRadius)
        minXMaxYCenter = CGPoint(x: cornerRadius, y: frame.size.height - cornerRadius)
        
        drawPath()
        
        shapeLayer.strokeColor = strokeColor?.cgColor
        shapeLayer.fillColor = fillColor?.cgColor
        shapeLayer.lineWidth = strokeWidth
        shapeLayer.path = path.cgPath
    }
    private func drawPath() {
        
        path.removeAllPoints()
        path.lineWidth = strokeWidth
        
        let minXMinYPoint: CGPoint = .zero
        let maxXMinYPoint: CGPoint = CGPoint(x: frame.size.width, y: 0)
        let maxXMaxYPoint: CGPoint = CGPoint(x: frame.size.width, y: frame.size.height)
        let minXMaxYPoint: CGPoint = CGPoint(x: 0, y: frame.size.height)
        
        let topPoint1: CGPoint = CGPoint(x: cornerRadius, y: 0)
        let topPoint2: CGPoint = CGPoint(x: frame.size.width - cornerRadius, y: 0)
        
        let rightPoint1: CGPoint = CGPoint(x: frame.size.width, y: cornerRadius)
        let rightPoint2: CGPoint = CGPoint(x: frame.size.width, y: frame.size.height - cornerRadius)
        
        let bottomPoint1: CGPoint = CGPoint(x: frame.size.width - cornerRadius, y: frame.size.height)
        let bottomPoint2: CGPoint = CGPoint(x: cornerRadius, y: frame.size.height)
        
        let leftPoint1: CGPoint = CGPoint(x: 0, y: frame.size.height - cornerRadius)
        let leftPoint2: CGPoint = CGPoint(x: 0, y: cornerRadius)
        
        path.move(to: leftPoint2)
        if maskedCorners.contains(.layerMinXMinYCorner) {
            path.addArc(withCenter: minXMinYCenter, radius: cornerRadius, startAngle: .pi, endAngle: .pi*3/2, clockwise: true)
        } else {
            path.addLine(to: minXMinYPoint)
            path.addLine(to: topPoint1)
        }
        
        path.addLine(to: topPoint2)
        
        if maskedCorners.contains(.layerMaxXMinYCorner) {
            path.addArc(withCenter: maxXMinYCenter, radius: cornerRadius, startAngle: -.pi/2, endAngle: 0, clockwise: true)
        } else {
            path.addLine(to: maxXMinYPoint)
            path.addLine(to: rightPoint1)
        }
        
        path.addLine(to: rightPoint2)

        if maskedCorners.contains(.layerMaxXMaxYCorner) {
            path.addArc(withCenter: maxXMaxYCenter, radius: cornerRadius, startAngle: 0, endAngle: .pi/2, clockwise: true)
        } else {
            path.addLine(to: maxXMaxYPoint)
            path.addLine(to: bottomPoint1)
        }
        
        path.addLine(to: bottomPoint2)
        
        if maskedCorners.contains(.layerMinXMaxYCorner) {
            path.addArc(withCenter: minXMaxYCenter, radius: cornerRadius, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        } else {
            path.addLine(to: minXMaxYPoint)
            path.addLine(to: leftPoint1)
        }
        
        path.addLine(to: leftPoint2)
        
        path.fill()
    }
    
}
