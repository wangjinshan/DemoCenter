//
//  PublishCenterView.swift
//  PublishPopView
//
//  Created by 山神 on 2019/9/17.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

protocol PublishCenterViewDataSource: class {
    func numberOfItems(centerView: PublishPopCenterView?) -> Int
    func item(centerView: PublishPopCenterView?, item: Int) -> PublishPopItem
}

protocol PublishCenterViewDelegate: class {
    func didSelectItem(with centerView: PublishPopCenterView?, andItem item: PublishPopItem?)
    func didSelectMore(with centerView: PublishPopCenterView?, andItem group: PublishPopItem?)
}

class PublishPopCenterView: UIView {

    weak var dataSource: PublishCenterViewDataSource?
    weak var delegate: PublishCenterViewDelegate?
    var homeButtons: [UIButton] = []
    var visableButtons: [UIButton] = []

    func reloadData() {
        guard let dataSource = dataSource else { return }
        homeButtons.forEach { (item) in
            item.removeFromSuperview()
        }
        homeButtons.removeAll()
        let count = dataSource.numberOfItems(centerView: self)
        var items:[PublishPopItem] = []
        for index in 0 ..< count {
            items.append(dataSource.item(centerView: self, item: index))
        }
        self.layoutButton(items: items)
        buttonPositonAnimation(isDismiss: false)
    }

    func scrollBack() {
        visableButtons.removeAll()
        homeButtons.forEach { (objc) in
            visableButtons.append(objc)
        }
    }

    func dismiss() {
        buttonPositonAnimation(isDismiss: true)
    }

}

extension PublishPopCenterView {

    func layoutButton(items:[PublishPopItem]) {
        var item: PublishPopItem
        for index in 0 ..< items.count {
            item = items[index]
            let button = PublishPopButton(type: .custom)
            button.setImage(UIImage(named: item.icon), for: .normal)
            button.imageView?.contentMode = .center
            button.setTitle(item.title, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(item.titleColor, for: .normal)
            button.titleLabel?.font = item.titleFont

            let x = CGFloat((index % 3)) * self.frame.size.width / 3.0
            let y = CGFloat((index / 3)) * self.frame.size.height / 2.0
            homeButtons.append(button)

            let width = CGFloat(self.frame.size.width / 3.0)
            let height = CGFloat(self.frame.size.height / 2)
            button.addTarget(self, action: #selector(didClickButton(button:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(didTouchButton(button:)), for: .touchDown)
            button.addTarget(self, action: #selector(didCancelButton(button:)), for: .touchDragInside)

            button.frame = CGRect(x: x, y: y, width: width, height: height)
            addSubview(button)
        }
    }

    func buttonPositonAnimation(isDismiss: Bool) {
        if visableButtons.count <= 0 {
            homeButtons.forEach { (button) in
                visableButtons.append(button)
            }
        }
        if isDismiss {
            removeAnimation()
        } else {
            moveInAnimation()
        }
    }

    @objc func didClickButton(button: UIButton) {
        guard let dataSource = dataSource else { return }
        button.scalingWithTime(time: 0.25, scale: 1)
        button.scalingWithTime(time: 0.25, scale: 1.7)
        button.fadeOutWithTime(time: 0.25)
        visableButtons.forEach { (objc) in
            let temp = objc
            if temp != button {
                temp.scalingWithTime(time: 0.25, scale: 0.3)
                temp.fadeOutWithTime(time: 0.25)
            }
        }

        if homeButtons.contains(button), let index = homeButtons.firstIndex(of: button) {
           let item = dataSource.item(centerView: self, item: index)
            delegate?.didSelectItem(with: self, andItem: item)
        }
    }

    @objc func didTouchButton(button: UIButton) {
        button.scalingWithTime(time: 0.15, scale: 1.2)
    }

    @objc func didCancelButton(button: UIButton) {
        button.scalingWithTime(time: 0.15, scale: 1)
    }

    func removeAnimation() {
        for (index, item) in visableButtons.enumerated() {
            let button = item
            let x = CGFloat(button.frame.origin.x)
            let y = CGFloat(button.frame.origin.y)
            let width = CGFloat(button.frame.size.width)
            let height = CGFloat(button.frame.size.height)
            let time = Double((visableButtons.count - index)) * 0.03
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: [], animations: {
                    button.alpha = 0
                    button.frame = CGRect(x: x, y: UIScreen.main.bounds.size.height - self.frame.origin.y + y, width: width, height: height)
                }, completion: { (_) in
                })
            })
        }
    }

    func moveInAnimation() {
        for (index, item) in visableButtons.enumerated() {
             let button = item
            let x = button.frame.origin.x
            let y = button.frame.origin.y
            let width = button.frame.size.width
            let height = button.frame.size.height
            button.frame = CGRect(x: x, y: UIScreen.main.bounds.size.height + y - frame.origin.y, width: width, height: height)
            button.alpha = 0.0
            let time = Double(index) * 0.03
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 25, options: [], animations: {
                    button.alpha = 1
                    button.frame = CGRect(x: x, y: y, width: width, height: height)
                }, completion: { (_) in
                })
            })
        }
    }

}

