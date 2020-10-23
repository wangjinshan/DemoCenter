//
//  TestView.swift
//  FormDemo
//
//  Created by 山神 on 2019/7/23.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit
import Eureka

class TestView: FormViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.red
        form
            +++ Section("Section2")
            <<< DateRow(){
                $0.tag = "MyRowTag3"
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }





    
}
