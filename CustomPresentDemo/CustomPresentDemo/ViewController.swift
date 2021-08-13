//
//  ViewController.swift
//  CustomPresentDemo
//
//  Created by 山神 on 2020/6/30.
//  Copyright © 2020 山神. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func presentPhoto(_ sender: UIButton) {
        let vc = PhototViewController()
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .overCurrentContext
        present(navi, animated: true) {

        }
    }

}
