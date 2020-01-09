//
//  KKXImageContentView.swift
//  KKXMobile
//
//  Created by ming on 2019/6/12.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit

public protocol KKXImageContentViewDelegate: AnyObject {
    func imageContentNumberOfImages(_ contentView: KKXImageContentView) -> Int
    func imageContent(_ contentView: KKXImageContentView, imageView: UIImageView, at index: Int)
}
extension KKXImageContentViewDelegate {
    func imageContent(_ contentView: KKXImageContentView, imageView: UIImageView, at index: Int) { }
}

@IBDesignable
public class KKXImageContentView: UIView {
    
    // MARK: -------- Properties --------
    
    public weak var delegate: KKXImageContentViewDelegate?
    
    public var imageTapClosure: (([UIImageView], Int) -> Void)?
    
    /// 占位图片
    public var placeholderImage: UIImage? {
        didSet {
            for i in 0..<imageViews.count {
                let imageView = imageViews[i]
                imageView.image = placeholderImage
            }
        }
    }
    
    /// 图片之间的距离，默认5
    @IBInspectable public var innerSpace: CGFloat = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    /// 最多显示图片数量，默 9
    @IBInspectable public var maxCount: Int = 9 {
        didSet {
            configureSubviews()
            setNeedsLayout()
        }
    }
    /// 每行显示图片的数量，默认3
    @IBInspectable public var column: Int = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    /// 四周边距默认UIEdgeInsets.zero
    @IBInspectable public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    

    // MARK: -------- Private Properties --------

    private var imageViews: [UIImageView] = []
    
    // MARK: -------- Init --------
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureSubviews()
    }
    
    // MARK: -------- Configure --------
    
    private func configureSubviews() {

        imageViews.removeAll()
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        
        for _ in 0..<maxCount {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true
            addSubview(imageView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapAction(_:)))
            imageView.addGestureRecognizer(tapGesture)
            
            imageViews.append(imageView)
        }
        reloadImageViews()
    }
    
    
    /// 根据图片数量显示imageView
    private func reloadImageViews() {
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            imageView.isHidden = (i >= numberOfImages())
            delegate?.imageContent(self, imageView: imageView, at: i)
        }
        setNeedsLayout()
    }
    
    // MARK: -------- Actions --------
    
    @objc private func imageTapAction(_ sender: UIGestureRecognizer) {
        if let imageView = sender.view as? UIImageView,
            let index = imageViews.firstIndex(of: imageView) {
            imageViews.filter { (imageView) -> Bool in
                imageView.isHidden == false
            }
            imageTapClosure?(imageViews, index)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            
            let space = innerSpace*CGFloat(column - 1) - contentInsets.left - contentInsets.right
            let imageWidth = (frame.size.width - space)/CGFloat(column)
            
            let originX = contentInsets.left + (imageWidth + innerSpace)*CGFloat(i%column)
            let originY = contentInsets.top + (imageWidth + innerSpace)*CGFloat(i/column)
            imageView.frame = CGRect(x: originX, y: originY, width: imageWidth, height: imageWidth)
        }
    }
    
    public func numberOfImages() -> Int {
        let count = delegate?.imageContentNumberOfImages(self) ?? 0
        return min(count, maxCount)
    }
    
}
