//
//  ViewController.swift
//  PublishPopView
//
//  Created by 山神 on 2019/9/17.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 60, height: 60))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(text), for: .touchUpInside)

        view.addSubview(button)

    }

   @objc func text() {
    let pop = PublishPopView(frame: view.bounds)
    pop.backgroundImageView.image = nil

    let item1 = PublishPopItem(title: "打卡", icon: "icon_60px_practise")

    let item2 = PublishPopItem(title: "打卡", icon: "icon_60px_practise")

    let item3 = PublishPopItem(title: "打卡", icon: "icon_60px_practise")

    let item4 = PublishPopItem(title: "打卡", icon: "icon_60px_practise")

    let item5 = PublishPopItem(title: "打卡", icon: "icon_60px_practise")

    let item6 = PublishPopItem(title: "打卡", icon: "icon_60px_practise")

    pop.showPopView(superView: self.view.window, items: [item1, item2,item3,item4,item5,item6]) { (item) in

    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//        pop.hide()
    })

    }

}

