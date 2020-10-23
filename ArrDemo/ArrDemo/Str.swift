//
//  Str.swift
//  ArrDemo
//
//  Created by 山神 on 2019/12/2.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

extension ViewController {

   class func base64Decode(string: String) -> String? {
        let data = Data(base64Encoded: string, options: [])
        if let data = data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    class func base64Encode(string: String) -> String? {
        let temp = string.removingPercentEncoding
        let data = temp?.data(using: .utf8)
        return data?.base64EncodedString(options: [])
    }

}

