//
//  UIKit+Extension.swift
//  SwiftCode
//
//  Created by shan on 2021/5/25.
//

import UIKit

class BundleClass { }

extension Bundle {
    class func sourcesBundle(name: String?) -> Bundle? {
        let bundle = Bundle(for: BundleClass.self)
        if let path = bundle.path(forResource: name, ofType: "bundle") {
            return Bundle(path: path)
        } else {
            return Bundle.main
        }
    }
}

extension UIImage {
    convenience init?(name: String, type: String? = "png", bundleName: String? = nil) {
        if let path = Bundle.sourcesBundle(name: bundleName)?.path(forResource: name, ofType: type) {
            self.init(contentsOfFile: path)
        }
        self.init(named: name)
    }
}
