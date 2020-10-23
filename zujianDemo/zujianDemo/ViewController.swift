//
//  ViewController.swift
//  zujianDemo
//
//  Created by 山神 on 2020/7/22.
//  Copyright © 2020 山神. All rights reserved.
//

import UIKit
import ZRouter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
    }

    @IBAction func presentAction(_ sender: UIButton) {
        Router.perform(to: RoutableView<ShopInput>(), path: .presentModally(from: self)) { (config, prepareModule) in

        }
    }
    
}

