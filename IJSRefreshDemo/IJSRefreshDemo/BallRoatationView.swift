//
//  BallRoatationView.swift
//  IJSRefreshDemo
//
//  Created by 山神 on 2019/9/19.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

extension UIView {

    func makeLoading(title: String? = "", enable: Bool = false) {
        var roundView: BallRoatationView?
        roundView = BallRoatationView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        guard let rView = roundView else {
            return
        }
        rView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addSubview(rView)
        bringSubviewToFront(rView)
        rView.backgroundColor = UIColor.clear
    }

    /// 移除加载动画
    func dismissLoading() {
        self.removeFromSuperview()
    }
}

class BallRoatationView: UIView {

    private let firstBallColor = UIColor(red: 220 / 255.0, green: 222 / 255.0 , blue: 225 / 255.0, alpha: 1)
    private let secondBallColor = UIColor(red: 220 / 255.0, green: 222 / 255.0 , blue: 225 / 255.0, alpha: 1)
    private let thirdBallColor = UIColor(red: 220 / 255.0, green: 222 / 255.0 , blue: 225 / 255.0, alpha: 1)

    private var radius: CGFloat = 4 // 半径
    private var animationDurtion: TimeInterval = 0.75
    private var centerPoint = CGPoint(x: 0, y: 0)

    let minScale: CGFloat = 10.0 / 8.0
    let midScale: CGFloat = 1
    let maxScale: CGFloat = 6.0 / 8.0
    let maxColorScale: CGFloat = 0.9
    let minColorScale: CGFloat = 0.6
    let distance: CGFloat = 14

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        initProgressBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var oneLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        return layer
    }()

    private lazy var twoLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        return layer
    }()

    private lazy var threeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        return layer
    }()
}

extension BallRoatationView {

    func initProgressBar() {
        centerPoint = CGPoint(x: UIScreen.main.bounds.size.width / 2.0 , y: bounds.height / 2)
        layer.addSublayer(oneLayer)
        layer.addSublayer(twoLayer)
        layer.addSublayer(threeLayer)
        oneLayer.fillColor = firstBallColor.cgColor
        twoLayer.fillColor = secondBallColor.cgColor
        threeLayer.fillColor = thirdBallColor.cgColor
    }

    func moveLeft(offSet: CGFloat) {
       let path = UIBezierPath(arcCenter: CGPoint(x: self.centerPoint.x - offSet, y: self.centerPoint.y), radius: self.radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        oneLayer.path = path.cgPath
    }

    func moveRight(offSet: CGFloat) {
        let path = UIBezierPath(arcCenter: CGPoint(x: self.centerPoint.x + offSet, y: self.centerPoint.y), radius: self.radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        threeLayer.path = path.cgPath
    }

    func moveCenter(offSet: CGFloat) {
        let path = UIBezierPath(arcCenter: CGPoint(x: self.centerPoint.x + offSet, y: self.centerPoint.y), radius: self.radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        twoLayer.path = path.cgPath
    }

    func startAnimation() {

        moveLeft(offSet: distance)
        moveCenter(offSet: 0)
        moveRight(offSet: distance)

        let oneScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        oneScaleAnimation.values = [maxScale, midScale, minScale]
        let oneOpactiyAniamtion = CAKeyframeAnimation(keyPath: "opacity")
        oneOpactiyAniamtion.values = [maxColorScale, maxColorScale, minColorScale]
        let oneGroup = CAAnimationGroup()
        oneGroup.animations = [oneScaleAnimation, oneOpactiyAniamtion]
        oneGroup.duration = animationDurtion
        oneGroup.beginTime = 0.12
        oneGroup.repeatCount = HUGE
        oneGroup.autoreverses = true

        oneLayer.add(oneGroup, forKey: nil)

        let twoFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        let twopath = CGMutablePath()
        twopath.move(to:  CGPoint(x: centerPoint.x, y: centerPoint.y))
        twoFrameAnimation.path = twopath
        twoFrameAnimation.keyTimes = [1.0] as [NSNumber]
        let twoScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        twoScaleAnimation.values = [maxScale, midScale, minScale]
        let twoOpactiyAniamtion = CAKeyframeAnimation(keyPath: "opacity")
        twoOpactiyAniamtion.values = [maxColorScale, minColorScale]
        let twoGroup = CAAnimationGroup()
        twoGroup.animations = [twoFrameAnimation, twoScaleAnimation, twoOpactiyAniamtion]
        twoGroup.duration = animationDurtion
        twoGroup.repeatCount = HUGE
        twoGroup.beginTime = 0.24
        twoGroup.autoreverses = true
        self.twoLayer.add(twoGroup, forKey: nil)

        let threeScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        threeScaleAnimation.values = [maxScale, midScale, minScale]
        let threeOpactiyAniamtion = CAKeyframeAnimation(keyPath: "opacity")
        threeOpactiyAniamtion.values = [minColorScale, maxColorScale, maxColorScale]
        let threeGroup = CAAnimationGroup()
        threeGroup.animations = [threeScaleAnimation, threeOpactiyAniamtion]
        threeGroup.duration = animationDurtion
        threeGroup.repeatCount = HUGE
        threeGroup.beginTime = 0.36
        threeGroup.autoreverses = true
        self.threeLayer.add(threeGroup, forKey: nil)
    }

    func stopAnimation() {
        oneLayer.removeAllAnimations()
        twoLayer.removeAllAnimations()
        threeLayer.removeAllAnimations()
    }
}

