//
//  PublishCustomButton.swift
//  PublishPopView
//
//  Created by 山神 on 2019/9/17.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class PublishPopButton: UIButton {

    let iconHeight = CGFloat(71)
    let titleHeight = CGFloat(30)

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: (contentRect.size.height - iconHeight - titleHeight) / 2, width: contentRect.size.width, height: iconHeight)
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: (contentRect.size.height - iconHeight - titleHeight) / 2 + iconHeight, width: contentRect.size.width, height: titleHeight)
    }
}

extension UIButton {
    func layoutButtonEdgeInsets(space: CGFloat) {
        var labelWidth: CGFloat = 0.0
        var imageEdgeInset = UIEdgeInsets.zero
        var labelEdgeInset = UIEdgeInsets.zero
        let imageWith = self.imageView?.frame.size.width
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        imageEdgeInset = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
        labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith! - space / 2.0, bottom: 0, right: imageWith! + space / 2.0)
        self.titleEdgeInsets = labelEdgeInset
        self.imageEdgeInsets = imageEdgeInset
    }
}

class PublishPopItem: NSObject {
    var title: String = ""
    var icon: String = ""
    var titleColor: UIColor = UIColor.black
    var titleFont: UIFont = UIFont.systemFont(ofSize: 16)

    init(title: String, icon: String, titleColor: UIColor = UIColor.black, titleFont: UIFont = UIFont.systemFont(ofSize: 16)) {
        self.title = title
        self.icon = icon
        self.titleColor = titleColor
        self.titleFont = titleFont
        super.init()
    }
}

extension UIView {

    func fadeInWithTime(time: TimeInterval) {
        alpha = 0
        UIView.animate(withDuration: time) {
            self.alpha = 1
        }
    }

    func fadeOutWithTime(time: TimeInterval) {
        alpha = 1
        UIView.animate(withDuration: time, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    func scalingWithTime(time: TimeInterval, scale: CGFloat) {
        UIView.animate(withDuration: time) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }

    func revolvingWithTime(time: TimeInterval, rotation: CGFloat) {
        UIView.animate(withDuration: time) {
            self.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
}
