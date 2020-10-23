//
//  PublishPopView.swift
//  PublishPopView
//
//  Created by 山神 on 2019/9/17.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class PublishPopView: UIView {

    let backgroundImageView: UIImageView = UIImageView()
    let centerView = PublishPopCenterView()
    var didSelectedBlock:((PublishPopItem?) -> Void)?
    var didClickTipButton:(() -> Void)?
    var didClickCloseButton:(() -> Void)?

    var items: [PublishPopItem] = []
    var tipButton = UIButton()
    var closeButtonWidth: CGFloat = 48
    var tipTopMargin: CGFloat = 40
    var closeTopMargin: CGFloat = 40
    var centerViewTopScale: CGFloat = 0.3
    var centerViewHeightScale: CGFloat = 0.4

    private let closeButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)

        addSubview(centerView)
        centerView.frame = CGRect(x: 0, y: frame.size.height * centerViewTopScale, width: frame.size.width, height: frame.size.height * centerViewHeightScale)
        centerView.dataSource = self
        centerView.delegate = self
        centerView.clipsToBounds = false

        tipButton.frame = CGRect(x: 30, y: centerView.frame.maxY + tipTopMargin, width: frame.size.width - 60, height: 24)
        tipButton.setTitle("想发布成绩？点击这里", for: .normal)
        tipButton.setImage(UIImage(named: "icon_12px_arrow_right"), for: .normal)
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tipButton.setTitleColor(UIColor(red: 158 / 255.0, green: 163 / 255.0, blue: 175 / 255.0, alpha: 1), for: .normal)
        addSubview(tipButton)
        tipButton.layoutButtonEdgeInsets(space: 6)
        tipButton.addTarget(self, action: #selector(tipButtonAction), for: .touchUpInside)
        tipButton.fadeInWithTime(time: 0.5)

        closeButton.setImage(UIImage(named: "icon_60px_practise"), for: .normal)

        closeButton.frame = CGRect(x: (frame.size.width - closeButtonWidth) / 2.0, y: tipButton.frame.maxY + closeTopMargin, width: closeButtonWidth, height: closeButtonWidth)
        addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        closeButton.revolvingWithTime(time: 0, rotation: CGFloat(Double.pi / 2))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tipButtonAction() {
        didClickTipButton?()
    }

    @objc func closeButtonAction() {
        didClickCloseButton?()
        hideItems()
        hide()
    }

    func showPopView(superView: UIView?, items: [PublishPopItem], didSelectedBlock:@escaping ((PublishPopItem?) -> Void)) {
        superView?.addSubview(self)
        self.didSelectedBlock = didSelectedBlock
        fadeInWithTime(time: 0.25)
        self.items = items
        showItems()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideItems()
        hide()
    }
}

extension PublishPopView {

    func showItems() {
        centerView.reloadData()
    }

    func hideItems() {
        centerView.dismiss()
    }

    func removeitemsComplete() {
        superview?.isUserInteractionEnabled = true
    }

    func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
            self.fadeOutWithTime(time: 0.35)
        })
        restoreCloseButton()
    }

    func restoreCloseButton() {
        closeButton.fadeOutWithTime(time: 0.25)
        closeButton.revolvingWithTime(time: 0.25, rotation: 0)
    }
}

extension PublishPopView: PublishCenterViewDataSource, PublishCenterViewDelegate {

    func numberOfItems(centerView: PublishPopCenterView?) -> Int {
        return items.count
    }

    func item(centerView: PublishPopCenterView?, item: Int) -> PublishPopItem {
        return items[item]
    }

    func didSelectItem(with centerView: PublishPopCenterView?, andItem item: PublishPopItem?) {
        didSelectedBlock?(item)
        hide()
    }
    func didSelectMore(with centerView: PublishPopCenterView?, andItem group: PublishPopItem?) {

    }
}
