//
//  KKXImageScrollView.swift
//  SwiftMobile
//
//  Created by ming on 2020/1/8.
//  Copyright © 2020 ming. All rights reserved.
//

import UIKit

public class KKXImageScrollView: UIScrollView {

    // MARK: -------- Properties --------
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var needsUpdateContent: Bool = true

    // MARK: -------- Init --------
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willChangeStatusBarOrientationNotification, object: nil)
    }
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(orientationWillChanged), name: UIApplication.willChangeStatusBarOrientationNotification, object: nil)
        delegate = self
        addSubview(imageView)
    }
    
    // MARK: -------- Actions --------
    
    public func setNeedsUpdateContentFrame() {
        needsUpdateContent = true
    }
    
    public func updateContentFrame() {
        setZoomScale(1.0, animated: true)
        
        let defaultW = min(frame.size.width, frame.size.height)
        let defaultH = defaultW
        var imageFitSize = CGSize(width: defaultW, height: defaultH)
        if let imageSize = imageView.image?.size {
            imageFitSize = imageSize.fitSize(in: bounds.size)
        }
        
        self.imageView.frame.size = imageFitSize
        
        let scrollViewSize = self.bounds.size
        let verticalPadding = imageFitSize.height < scrollViewSize.height ? (scrollViewSize.height - imageFitSize.height)/2:0
        let horizontalPadding = imageFitSize.width < scrollViewSize.width ? (scrollViewSize.width - imageFitSize.width)/2:0
        self.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        setZoomScale(1.0, animated: true)
        print(imageFitSize, bounds)
    }
    
    private func updateZoomContentInsets() {
        let contentSize = self.contentSize;
        let scrollViewSize = self.bounds.size;
        
        let verticalPadding = contentSize.height < scrollViewSize.height ? (scrollViewSize.height - contentSize.height) / 2 : 0;
        let horizontalPadding = contentSize.width < scrollViewSize.width ? (scrollViewSize.width - contentSize.width) / 2 : 0;
        
        contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }

    @objc private func orientationWillChanged() {
        setNeedsUpdateContentFrame()
    }
    
    // MARK: -------- Layout --------
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if needsUpdateContent {
            updateContentFrame()
            needsUpdateContent = false
        }
    }

}

// MARK: - ======== UIScrollViewDelegate ========
extension KKXImageScrollView: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateZoomContentInsets()
    }
}
