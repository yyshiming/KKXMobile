//
//  KKXImagePreviewVC.swift
//
//  Created by ming on 2019/6/17.
//  Copyright © 2019 ming. All rights reserved.
//

import UIKit
import Photos

public protocol KKXImagePreviewDelegate: AnyObject {
    func imagePreviewNumberOfPhotos(_ preview: KKXImagePreviewVC) -> Int
    func imagePreview(_ preview: KKXImagePreviewVC, imageFor imageView: UIImageView, at index: Int, completion: (@escaping (UIImage?) -> Void))
}
extension KKXImagePreviewDelegate {
    public func imagePreview(_ preview: KKXImagePreviewVC, imageFor imageView: UIImageView, at index: Int, completion: (@escaping (UIImage?) -> Void)) { }
}

private let KKXPhotoCellIdentifier = "KKXImagePreviewCell"
public class KKXImagePreviewVC: UIViewController {
    
    // MARK: -------- Properties --------
    
    public weak var delegate: KKXImagePreviewDelegate?
    public var tappedViews: [UIImageView]?
    public var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
        }
    }
    public var placeholder: UIImage?
    public var canDelete: Bool = false
    public var itemSpacing: CGFloat = 10 {
        didSet {
            let width = view.frame.size.width*CGFloat(photoCount) + CGFloat(max(0, photoCount - 1))*itemSpacing
            collectionView.contentSize = CGSize(width: width, height: 0)
            layout.minimumLineSpacing = itemSpacing
            collectionView.collectionViewLayout = layout
        }
    }
    public var photoCount: Int {
        delegate?.imagePreviewNumberOfPhotos(self) ?? 0
    }
    
    // MARK: -------- Private Properties --------
    
    private let layout = KKXPhotoFlowLayout.init()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentOffset = .zero
        collectionView.register(KKXImagePreviewCell.self, forCellWithReuseIdentifier: KKXPhotoCellIdentifier)
        
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = currentIndex
        pageControl.numberOfPages = photoCount
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private let activityView: KKXActivityView = KKXActivityView()
    private var statusBarHidden: Bool = true
    private var statusBarStyle: UIStatusBarStyle = UIApplication.shared.statusBarStyle
    private var originStatusBarHidden: Bool = true
    
    // MARK: -------- View Life Cycle --------
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originStatusBarHidden = UIApplication.shared.isStatusBarHidden
        statusBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarHidden = originStatusBarHidden
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willDeletePhoto), name: NSNotification.Name.kkx_imageWillDelete, object: nil)
        configureSubviews()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let itemWidth = view.frame.size.width + itemSpacing
        layout.itemSize = CGSize(width: itemWidth, height: view.frame.size.height)
        
        collectionView.collectionViewLayout = layout
        collectionView.frame = CGRect(x: 0, y: 0, width: itemWidth, height: view.frame.size.height)
        collectionView.contentOffset = CGPoint(x: CGFloat(currentIndex)*itemWidth, y: 0)
        
    }
    
    // MARK: -------- Configuration --------
    
    private func configureSubviews() {
        view.backgroundColor = .black
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let width = view.frame.size.width*CGFloat(photoCount) + CGFloat(max(0, photoCount - 1))*itemSpacing
        collectionView.contentSize = CGSize(width: width, height: 0)
        view.addSubview(collectionView)
        
        view.addSubview(pageControl)
        configureConstraint()
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        singleTapGesture.delaysTouchesBegan = true
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(singleTapGesture)
        view.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    private func configureConstraint() {
        let attributes: [NSLayoutConstraint.Attribute] = [
            .leading,
            .trailing,
            .bottom,
        ]
        for attribute in attributes {
            NSLayoutConstraint(
                item: pageControl,
                attribute: attribute,
                relatedBy: .equal,
                toItem: view,
                attribute: attribute,
                multiplier: 1.0,
                constant: 0
            ).isActive = true
        }
        NSLayoutConstraint(
            item: pageControl,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 44.0
        ).isActive = true
    }

    // MARK: -------- Actions --------
    
    @objc private func willDeletePhoto() {
        singleTapAction()
    }
    
    @objc private func singleTapAction() {
        let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? KKXImagePreviewCell
        cell?.resetZoomScale(false)
        if let _ = navigationController {
            let hidden = UIApplication.shared.isStatusBarHidden
            statusBarHidden  = !hidden
            setNeedsStatusBarAppearanceUpdate()
            navigationController?.setNavigationBarHidden(!hidden, animated: true)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func doubleTapAction() {
        let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? KKXImagePreviewCell
        cell?.changeZoomScale()
    }
    
    private func showAlert(_ image: UIImage, index: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "保存图片到相册", style: .default) { [weak self](action) in
            self?.savePhoto(image, index: index)
        }
        alertController.addAction(saveAction)
        
        if canDelete {
            let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (action) in
                NotificationCenter.default.post(name: Notification.Name.kkx_imageWillDelete, object: nil)
            }
            alertController.addAction(deleteAction)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func savePhoto(_ image: UIImage?, index: Int) {
        guard let _ = image else {
            return
        }
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.activityView.show(in: self.view)
                }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image!)
                }) { (success, error) in
                    DispatchQueue.main.async {
                        if success {
                            self.activityView.mode = .text
                            self.activityView.label.text = "图片已保存到您的相册！"
                        } else {
                            print("图片保存失败：" + (error?.localizedDescription ?? ""))
                        }
                        self.activityView.hide()
                    }
                }
            default:
                break
            }
        }
    }
}

extension KKXImagePreviewVC {

    public override var shouldAutorotate: Bool {
        true
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown
    }
    
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }
    
    public override var prefersStatusBarHidden: Bool {
        statusBarHidden
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
    
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .fade
    }
    
}

// MARK: - ======== UICollectionViewDataSource ========
extension KKXImagePreviewVC: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KKXPhotoCellIdentifier, for: indexPath) as! KKXImagePreviewCell
        cell.longPressHandler = { [weak self](image) in
            self?.showAlert(image, index: indexPath.item)
        }
        delegate?.imagePreview(self, imageFor: cell.scrollView.imageView, at: indexPath.item, completion: { (image) in
            cell.resizeImageView(with: image)
        })
        return cell
    }
    
}

// MARK: - ======== UICollectionViewDelegate ========
extension KKXImagePreviewVC: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? KKXImagePreviewCell)?.resetZoomScale(false)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x + scrollView.frame.size.width/2
        let index = Int(offset/scrollView.frame.size.width)
        if index < photoCount && index != currentIndex {
            currentIndex = index
        }
        pageControl.currentPage = currentIndex
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = targetContentOffset.pointee.x + scrollView.frame.size.width/2
        let index = Int(offset/scrollView.frame.size.width)
        if index < photoCount && index != currentIndex {
            currentIndex = index
        }
        pageControl.currentPage = currentIndex

    }
    
}

// MARK: - ======== UIViewControllerTransitioningDelegate ========
extension KKXImagePreviewVC: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? KKXImagePreviewCell
        let transition = KKXImagePresentTransition()
        transition.tappedView = tappedViews?[currentIndex]
        transition.image = cell?.scrollView.imageView.image
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? KKXImagePreviewCell
        let transition = KKXImageDismissTransition()
        transition.tappedView = tappedViews?[currentIndex]
        transition.image = cell?.scrollView.imageView.image
        return transition
    }
    
}

// MARK: - ======== KKXPhotoFlowLayout ========
public class KKXPhotoFlowLayout: UICollectionViewFlowLayout {
    
}

extension Notification.Name {
    public static let kkx_imageWillDelete = Notification.Name.init("imageWillDelete")
}
