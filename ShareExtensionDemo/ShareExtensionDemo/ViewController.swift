//
//  ViewController.swift
//  ShareExtensionDemo
//
//  Created by 山神 on 2019/5/31.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = UIColor.green
        
         UserDefaults.standard.set("10000", forKey: "jmTodayExtensionDemo")
    
          let title = UserDefaults.standard.object(forKey: "jmTodayExtensionDemo") as? String
        
    }


}

