//
//  XHBActivityLoadingView.swift
//  XHBActivityLoading
//
//  Created by 顾鹏凌 on 2019/9/27.
//  Copyright © 2019 gupengling. All rights reserved.
//

import UIKit
protocol XHBActivityAnimationProtocol: NSObject {
    func setupAnimationInLayer(layer: CALayer, size: CGSize, tintColor: UIColor)
}

class XHBActivityBaseAnimation: NSObject, XHBActivityAnimationProtocol {
    func setupAnimationInLayer(layer: CALayer, size: CGSize, tintColor: UIColor) {

    }

    func createBasicAnimation(keyPath: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.isRemovedOnCompletion = false
        return animation
    }

    func createKeyFrameAnimation(keyPath: String) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.isRemovedOnCompletion = false
        return animation
    }

    func createAnimationGroup() -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.isRemovedOnCompletion = false
        return animationGroup
    }

}
class SPActivityBallAnimation: XHBActivityBaseAnimation {

    override func setupAnimationInLayer(layer: CALayer, size: CGSize, tintColor: UIColor) {
        super.setupAnimationInLayer(layer: layer, size: size, tintColor: tintColor)
        let timeBegins = [0.15, 0.3, 0.45]
        let circlePadding = CGFloat(5.0)
        let circleSize = (size.width - 2 * circlePadding) / CGFloat( timeBegins.count)
        let y = (layer.bounds.size.height - circleSize) / 2

        let duration = 0.5
        for i in 0 ..< 3 {
            let circle = CAShapeLayer()
            let xx = CGFloat(i - 1) * 1 * 15
            circle.frame = CGRect(x: xx + CGFloat( i) * 5.0, y: y, width: circleSize, height: circleSize)
            circle.backgroundColor = tintColor.cgColor
            circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            circle.opacity = 1.0
            circle.cornerRadius =  circle.bounds.size.width / 2.0
            let xxx = CGFloat(1 - i) * 1 * 15
            let circlePath = UIBezierPath(roundedRect: CGRect(x: xxx, y: 0, width: circleSize, height: circleSize), cornerRadius: CGFloat(circleSize / 2))
            circle.path = circlePath.cgPath

            let scaleAnimation = createKeyFrameAnimation(keyPath: "transform")
            scaleAnimation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.75, 0.75, 0)),
                                     NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 0))]

            let opacityAnimation = createKeyFrameAnimation(keyPath: "opacity")
            opacityAnimation.values = [0.25, 1.0]

            let animation = createAnimationGroup()
            animation.autoreverses = true
            animation.beginTime = timeBegins[i]
            animation.repeatCount = HUGE
            animation.duration = duration
            animation.animations = [scaleAnimation, opacityAnimation]
            let timingFunction = CAMediaTimingFunction(name: .linear)
            animation.timingFunction = timingFunction

            layer.addSublayer(circle)

            circle.add(animation, forKey: "animation")
        }
    }
}

open class XHBActivityLoadingView: UIView {
    internal var animationLayer = CALayer()
    open var animating = false

    init(frame: CGRect, size: CGSize = CGSize(width: 40, height: 40)) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        animationLayer.frame = layer.bounds
        layer.addSublayer(animationLayer)

        setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
    }

    var pullingPercent: CGFloat = 0 {
        didSet {
            if let lays = self.animationLayer.sublayers {
                let tintColorRef = loadTintColor.cgColor

                for i in 0 ..< lays.count {
                    let sublayer = lays[i]
                    sublayer.backgroundColor = UIColor.clear.cgColor
                    if sublayer.isKind(of: CAShapeLayer.self) {
                        sublayer.backgroundColor = UIColor.clear.cgColor

                        let shapeLayer = sublayer as! CAShapeLayer

                        shapeLayer.fillColor = tintColorRef

                        let xx = CGFloat(i - 1) * self.pullingPercent * 15
                        let circleSize = 10
                        let xxx = CGFloat(1 - i) * self.pullingPercent * 15

                        let circlePath = UIBezierPath(roundedRect: CGRect(x: Int(xx + xxx), y: 0, width: circleSize, height: circleSize), cornerRadius: CGFloat(circleSize / 2))
                        shapeLayer.path = circlePath.cgPath
                    }
                }
            }
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        animationLayer.frame = bounds
        let an = animating
        if an {
            stopAnimating()
        }
        setupAnimation()
        if an {
            startAnimating()
        }
    }

    private func setupAnimation() {
        animationLayer.sublayers = nil
        let animation = SPActivityBallAnimation()
        animation.setupAnimationInLayer(layer: animationLayer, size: CGSize(width: 40, height: 40), tintColor: .white)
        animationLayer.speed = 0.0
    }

    open var loadTintColor: UIColor = UIColor.white {
        willSet {
            if loadTintColor != newValue {
                let tintColorRef = newValue.cgColor
                for sublayer in animationLayer.sublayers ?? [] {
                    sublayer.backgroundColor = tintColorRef

                    if sublayer.isKind(of: CAShapeLayer.self) {
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.strokeColor = tintColorRef
                        shapeLayer.fillColor = tintColorRef
                    }
                }
            }
        }
    }
}

extension XHBActivityLoadingView {
    open func startAnimating() {
        if animationLayer.sublayers?.count == 0 {
            setupAnimation()
        }

        isHidden = false
        animationLayer.speed = 1.0
        animating = true
    }
    open func stopAnimating() {
        isHidden = true
        animationLayer.speed = 0.0
        animating = false
    }
}
