//
//  KKXImagePreviewCell.swift
//  SwiftMobile
//
//  Created by ming on 2020/1/8.
//  Copyright © 2020 ming. All rights reserved.
//

import UIKit

public class KKXImagePreviewCell: UICollectionViewCell {
    
    // MARK: -------- Properties --------
    
    public let scrollView = KKXImageScrollView()
    public var longPressHandler: ((UIImage) -> Void)?
    
    // MARK: -------- Private Properties --------
    
    private var longPressGesture: UILongPressGestureRecognizer {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        return longPressGesture
    }
    
    // MARK: -------- Init --------
    
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
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.5
        addSubview(scrollView)
        addGestureRecognizer(longPressGesture)
    }
    
    // MARK: -------- Actions --------
    
    public func resetZoomScale(_ animated: Bool = true) {
        scrollView.setZoomScale(1.0, animated: animated)
    }
    
    public func changeZoomScale(_ animated: Bool = true) {
        if scrollView.zoomScale < scrollView.maximumZoomScale {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: animated)
        }
        else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: animated)
        }
    }
    
    public func resizeImageView(with image: UIImage?) {
        if let _ = image {
            scrollView.imageView.image = image
            scrollView.updateContentFrame()
        }
    }
    
    @objc private func longPressAction(_ sender: UILongPressGestureRecognizer) {
            switch sender.state {
            case .began:
                if let image = scrollView.imageView.image {
                    longPressHandler?(image)
                }
            default:
                break
            }
    }
    
    // MARK: -------- Layout --------
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width - 10, height: frame.size.height)
    }

}
