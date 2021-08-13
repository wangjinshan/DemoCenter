//
//  DisplayViewManager.swift
//  blackboard
//
//  Created by roni on 2019/4/29.
//  Copyright © 2019 xkb. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Core

let hookDisplayViewIsShow = "HOOKDISPLAYVIEWISSHOW"

class DisplayViewManager: NSObject {

    @objc static let sharedInstance = DisplayViewManager()

    private override init() {}

    private var displayView: HookDisplayView?

    func show() {
        if displayView == nil {
            displayView = HookDisplayView(frame: CGRect(x: 0, y: 200, width: ScreenWidth * 0.75, height: 400))
        }
        let window = UIApplication.shared.keyWindow
        window?.addSubview(displayView!)
        displayView!.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(200)
            make.size.equalTo(CGSize(width: ScreenWidth * 0.75, height: 400))
        }
    }

    var isHidden: Bool = false {
        didSet {
            displayView?.isHidden = isHidden
        }
    }

    func remove() {
        if displayView?.superview != nil {
            displayView?.removeFromSuperview()
            displayView = nil
        }
    }

    @objc func setViewDidLoadDesc(texts: [String: String]) {
        guard let displayView = displayView else {
            return
        }
        displayView.setViewDidLoadDesc(texts: texts)
        delay(0.2) {
            let window = UIApplication.shared.keyWindow
            window?.bringSubviewToFront(displayView)
        }
    }

    @objc func setClickDesc(_ view: UIView, texts: [String: String]) {
        guard let displayView = displayView else {
            return
        }
        displayView.setItemDesc(view, texts: texts)
        delay(0.2) {
            let window = UIApplication.shared.keyWindow
            window?.bringSubviewToFront(displayView)
        }
    }
}
