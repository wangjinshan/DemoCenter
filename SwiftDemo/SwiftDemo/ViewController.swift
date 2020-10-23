//
//  ViewController.swift
//  SwiftDemo
//
//  Created by 山神 on 2019/7/8.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        let demo = Demo(name: .Night)
        demo.loadName(theme: .Day)
        
        let temp =  NSArray()
        temp.adding("weq")
        temp.adding(NSObject.init())
        
        
    }


}

