//
//  KKXImageTransition.swift
//  SwiftMobile
//
//  Created by ming on 2020/1/8.
//  Copyright © 2020 ming. All rights reserved.
//

import UIKit

public class KKXImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var tappedView: UIImageView?
    public var image: UIImage?
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.4
    }
    
}

/// 自定义Present动画
public class KKXImagePresentTransition: KKXImageTransition {
    
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .black
        containerView.addSubview(toView)
        toView.frame = containerView.bounds
        
        guard let tapView = tappedView else {
            transitionContext.completeTransition(true)
            return
        }
        
        toView.isHidden = true
        fromView.isHidden = true

        let startFrame = tapView.superview!.convert(tapView.frame, to: containerView)
        var endSize = startFrame.size.fitSize(in: containerView.frame.size)
        let animateImage = image ?? tapView.image
        if let size = animateImage?.size, size != .zero {
            endSize = size.fitSize(in: containerView.frame.size)
        }
        
        // 创建动画view，动画结束后移除
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        containerView.addSubview(imageV)
        
        imageV.image = animateImage
        imageV.frame = startFrame
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            imageV.frame.size = endSize
            imageV.center = CGPoint(x: containerView.frame.size.width/2, y: containerView.frame.size.height/2)
        }) { (finished) in
            fromView.isHidden = false
            toView.isHidden = false
            imageV.removeFromSuperview()
            
            let wasCancelled = transitionContext.transitionWasCancelled
            if wasCancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}

/// 自定义dismiss动画
class KKXImageDismissTransition: KKXImageTransition {
    
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.frame = containerView.bounds
        
        guard let tapView = tappedView else {
            transitionContext.completeTransition(true)
            return
        }
        
        // 把点击视图的位置转换到containerView中
        let endFrame = tapView.superview!.convert(tapView.frame, to: containerView)
        var startSize = endFrame.size.fitSize(in: containerView.frame.size)
        let animateImage = image ?? tapView.image
        if let size = animateImage?.size, size != .zero {
            startSize = size.fitSize(in: containerView.frame.size)
        }
        
        // 创建动画view，动画结束后移除
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        containerView.addSubview(imageV)
        
        imageV.image = animateImage
        imageV.frame.size = startSize
        imageV.center = CGPoint(x: containerView.frame.size.width/2, y: containerView.frame.size.height/2)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            imageV.frame = endFrame
        }) { (finished) in
            imageV.removeFromSuperview()
            let wasCancelled = transitionContext.transitionWasCancelled
            if wasCancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
}

extension CGSize {
    /// size范围内等比缩放
    public func fitSize(in size: CGSize) -> CGSize {
        guard height > 0, size.height > 0 else {
            return .zero
        }
        
        let scale1 = width/height
        let scale2 = size.width/size.height
        
        var newWidth = size.width
        var newHeight = size.height
        if scale1 > scale2 {
            newHeight = newWidth/scale1
        } else {
            newWidth = newHeight*scale1
        }
        return CGSize(width: newWidth, height: newHeight)
    }
}
