//
//  String+Extension.swift
//  SwiftCode
//
//  Created by shan on 2021/6/25.
//

import Foundation

extension String {
    func filterNumbers() -> [Int] {
        if self.isEmpty { return [] }
        let regex = try? NSRegularExpression(pattern: "\\d+", options: [])
        let matches = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        matches?.forEach({ item in
            print(item)
        })
        return []
    }
}
