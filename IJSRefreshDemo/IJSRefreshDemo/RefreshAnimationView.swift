//
//  RefreshAnimationView.swift
//  IJSRefreshDemo
//
//  Created by 山神 on 2019/10/9.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

protocol RefreshAnimationViewProtocol: class {
    func setupAnimation()
}

extension RefreshAnimationViewProtocol {
    func setupAnimation() {}
}

class RefreshAnimationBaseView: UIView, RefreshAnimationViewProtocol {
    var leftView = UIView()
    var centerView = UIView()
    var rightView = UIView()
    let itemHeight = 8.0
    let itemColor = UIColor(red: 220 / 255.0, green: 222 / 255.0, blue: 225 / 255.0, alpha: 1)
    let distance: CGFloat = 14

    override init(frame: CGRect) {
        super.init(frame: frame)
        leftView = createCircle()
        addSubview(leftView)

        centerView = createCircle()
        addSubview(centerView)

        rightView = createCircle()
        addSubview(rightView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var pullingPercent: CGFloat = 0 {
        didSet {
            leftView.center = CGPoint(x: centerView.center.x - pullingPercent, y: centerView.center.y)
            rightView.center = CGPoint(x: centerView.center.x + pullingPercent, y: centerView.center.y)
        }
    }

    func startAnimation() {
        pullingPercent = distance
        setupAnimation()
    }

    func stopAnimation() {
        leftView.layer.removeAllAnimations()
        centerView.layer.removeAllAnimations()
        rightView.layer.removeAllAnimations()
    }

    func setupAnimation() {}

    private func createCircle() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: itemHeight, height: itemHeight))
        view.center = center
        view.layer.cornerRadius = CGFloat(itemHeight / 2.0)
        view.layer.masksToBounds = true
        view.backgroundColor = itemColor
        return view
    }

}

extension RefreshAnimationBaseView {

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

class RefreshAnimationView: RefreshAnimationBaseView {
    override func setupAnimation() {
        let timeBegins = [0.2, 0.4, 0.6]
        let duration = 0.6
        for i in 0..<3 {
            let scaleAnimation = createKeyFrameAnimation(keyPath: "transform")
            scaleAnimation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 0)),
                                     NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 0)),
                                     NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 0))]

            let opacityAnimation = createKeyFrameAnimation(keyPath: "opacity")
            opacityAnimation.values = [0.6, 1.0]

            let animation = createAnimationGroup()
            animation.autoreverses = true
            animation.beginTime = timeBegins[i]
            animation.repeatCount = HUGE
            animation.duration = duration
            animation.animations = [scaleAnimation, opacityAnimation]
            let timingFunction = CAMediaTimingFunction(name: .linear)
            animation.timingFunction = timingFunction
            switch i {
            case 0:
                leftView.layer.add(animation, forKey: "animation")
            case 1:
                centerView.layer.add(animation, forKey: "animation")
            case 2:
                rightView.layer.add(animation, forKey: "animation")
            default:
                break
            }
        }
    }
}
