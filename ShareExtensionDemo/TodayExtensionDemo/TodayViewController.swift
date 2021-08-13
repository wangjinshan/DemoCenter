//
//  TodayViewController.swift
//  TodayDemo
//
//  Created by 山神 on 2019/5/31.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 100)
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded // 支持折叠

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 15, y: 40, width: UIScreen.main.bounds.size.width  - 30, height: 44)
        button.setImage(UIImage(named: "弹窗头像"), for: .normal)
        button.backgroundColor = UIColor.green
        button.imageView?.contentMode = .scaleAspectFit
        view.addSubview(button)
        button.addTarget(self, action: #selector(openApp), for: .touchUpInside)

        let title = UserDefaults.standard.object(forKey: "jmTodayExtensionDemo") as? String

        button.setTitle(title, for: .normal)

    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    /// 展开和折叠使用
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: 0, height: 400)
        }
    }

    @objc func openApp() {

        extensionContext?.open(URL(string: "TodayDemo://")!, completionHandler: { (_) in

        })

    }

}
