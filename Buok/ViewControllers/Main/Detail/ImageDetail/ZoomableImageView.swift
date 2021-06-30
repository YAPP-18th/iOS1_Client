//
//  ZoomableImageView.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroUI
import Kingfisher
import SnapKit

@objc public protocol ZoomableImageViewDelegate: UIScrollViewDelegate {
    func zoomableImageViewDidChangeOrientation(imageView: ZoomableImageView)

    func zoomableImageViewDidLoadImage(imageView: ZoomableImageView)
}

public class ZoomableImageView: UIScrollView {
    static let kZoomInFactorFromMinWhenDoubleTap: CGFloat = 2

    @objc open var imageContentMode: ScaleMode = .widthFill
    @objc open var initialOffset: Offset = .begining

    @objc public private(set) var zoomView: UIImageView?

    @objc open weak var zoomableImageViewDelegate: ZoomableImageViewDelegate?
    var imageSize = CGSize.zero
    private var pointToCenterAfterResize = CGPoint.zero
    private var scaleToRestoreAfterResize: CGFloat = 1.0
    var maxScaleFromMinScale: CGFloat = 3.0

    override open var frame: CGRect {
        willSet {
            if frame.equalTo(newValue) == false, newValue.equalTo(CGRect.zero) == false, imageSize.equalTo(CGSize.zero) == false {
                prepareToResize()
            }
        }

        didSet {
            if frame.equalTo(oldValue) == false, frame.equalTo(CGRect.zero) == false, imageSize.equalTo(CGSize.zero) == false {
                recoverFromResizing()
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func initialize() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(changeOrientationNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc public func adjustFrameToCenter() {
        guard let unwrappedZoomView = zoomView else {
            return
        }

        var frameToCenter = unwrappedZoomView.frame

        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        unwrappedZoomView.frame = frameToCenter
    }

    private func prepareToResize() {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        pointToCenterAfterResize = convert(boundsCenter, to: zoomView)

        scaleToRestoreAfterResize = zoomScale

        if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            scaleToRestoreAfterResize = 0
        }
    }

    private func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()

        let maxZoomScale = max(minimumZoomScale, scaleToRestoreAfterResize)
        zoomScale = min(maximumZoomScale, maxZoomScale)

        let boundsCenter = convert(pointToCenterAfterResize, to: zoomView)

        var offset = CGPoint(x: boundsCenter.x - bounds.size.width / 2.0, y: boundsCenter.y - bounds.size.height / 2.0)

        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()

        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)

        realMaxOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxOffset)

        contentOffset = offset
    }

    private func maximumContentOffset() -> CGPoint {
        return CGPoint(x: contentSize.width - bounds.width, y: contentSize.height - bounds.height)
    }

    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }

    // MARK: - Set up

    open func setup() {
        var topSupperView = superview

        while topSupperView?.superview != nil {
            topSupperView = topSupperView?.superview
        }
        topSupperView?.layoutIfNeeded()
    }

    // MARK: - Display image

    @objc open func display(imageUrl: URL) {
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
        }

        KingfisherManager.shared.retrieveImage(with: imageUrl, completionHandler: { result in
            switch result {
            case let .success(value):
                self.zoomView = UIImageView(image: value.image)
                self.zoomView!.isUserInteractionEnabled = true
                self.addSubview(self.zoomView!)

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGestureRecognizer(_:)))
                tapGesture.numberOfTapsRequired = 2
                self.zoomView!.addGestureRecognizer(tapGesture)

                self.configureImageForSize(value.image.size)
            case let .failure(error):
                ErrorLog("Error: \(error)")
            }
        })
    }

    @objc open func display(image: UIImage) {
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
        }
        zoomView = UIImageView(image: image)
        zoomView!.isUserInteractionEnabled = true
        addSubview(zoomView!)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRecognizer(_:)))
        tapGesture.numberOfTapsRequired = 2
        zoomView!.addGestureRecognizer(tapGesture)

        configureImageForSize(image.size)
    }

    private func configureImageForSize(_ size: CGSize) {
        imageSize = size
        contentSize = imageSize
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale

        switch initialOffset {
        case .begining:
            contentOffset = CGPoint.zero
        case .center:
            let xOffset = contentSize.width < bounds.width ? 0 : (contentSize.width - bounds.width) / 2
            let yOffset = contentSize.height < bounds.height ? 0 : (contentSize.height - bounds.height) / 2

            switch imageContentMode {
            case .aspectFit:
                contentOffset = CGPoint.zero
            case .aspectFill:
                contentOffset = CGPoint(x: xOffset, y: yOffset)
            case .heightFill:
                contentOffset = CGPoint(x: xOffset, y: 0)
            case .widthFill:
                contentOffset = CGPoint(x: 0, y: yOffset)
            }
        }

        zoomableImageViewDelegate?.zoomableImageViewDidLoadImage(imageView: self)
    }

    private func setMaxMinZoomScalesForCurrentBounds() {
        let xScale = bounds.width / imageSize.width
        let yScale = bounds.height / imageSize.height

        var minScale: CGFloat = 1

        switch imageContentMode {
        case .aspectFill:
            minScale = max(xScale, yScale)
        case .aspectFit:
            minScale = min(xScale, yScale)
        case .widthFill:
            minScale = xScale
        case .heightFill:
            minScale = yScale
        }

        let maxScale = maxScaleFromMinScale * minScale
        if minScale > maxScale {
            minScale = maxScale
        }

        maximumZoomScale = maxScale
        minimumZoomScale = minScale * 0.999
    }

    // MARK: - Gesture

    @objc func doubleTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if zoomScale >= maximumZoomScale / 2.0 {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let center = gestureRecognizer.location(in: gestureRecognizer.view)
            let zoomRect = zoomRectForScale(ZoomableImageView.kZoomInFactorFromMinWhenDoubleTap * minimumZoomScale, center: center)
            zoom(to: zoomRect, animated: true)
        }
    }

    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero

        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width = frame.size.width / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)

        return zoomRect
    }

    open func refresh() {
        if let image = zoomView?.image {
            display(image: image)
        }
    }

    // MARK: - Actions

    @objc func changeOrientationNotification() {
        DispatchQueue.main.async {
            self.configureImageForSize(self.imageSize)
            self.zoomableImageViewDelegate?.zoomableImageViewDidChangeOrientation(imageView: self)
        }
    }
}

extension ZoomableImageView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        zoomableImageViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        zoomableImageViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        zoomableImageViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        zoomableImageViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        zoomableImageViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        zoomableImageViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        zoomableImageViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        zoomableImageViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        zoomableImageViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    public func scrollViewShouldScrollToTop(_: UIScrollView) -> Bool {
        return false
    }

    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        zoomableImageViewDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }

    public func viewForZooming(in _: UIScrollView) -> UIView? {
        return zoomView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
        zoomableImageViewDelegate?.scrollViewDidZoom?(scrollView)
    }
}
