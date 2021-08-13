//
//  Arr.swift
//  ArrDemo
//
//  Created by 山神 on 2019/12/2.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

extension ViewController {

    /// 数组的基本函数
    func demo() {
        // TODO:删除前面
        let numbers2 = [10, 22, 333, 3334, 3335]
        print(numbers2.dropFirst(2))   // Prints "333, 3334, 3335"
        print(numbers2.dropFirst(10)) // Prints "[]"
        print(numbers2.dropLast(2))

        // TODO:第一个元素匹配值为准,第一个满足删除第一个,返回其他,第一个不满足则返回其他全部, 去其他元素
        let arr3 = numbers2.drop { (item) -> Bool in
            return item == 10
        }
        print(arr3) // [22, 333, 3334, 3335]

        // TODO:返回包含初始元素的子序列，直到谓词返回false并跳过其余元素 ,只取第一个元素
        let str1 = ["dwdw", "cwcvwv", "aaaa", "dwedewdwe"]
        let temp3 = str1.prefix { (item) -> Bool in
            return item == "dwdw"
        }
        print(temp3)//  "dwdw"

        // TODO:数组后几个
        let numbers = [1, 2, 3, 4, 3, 4, 5, 3]
        print(numbers.suffix(2))   // Prints "[4, 5]"
        print(numbers.suffix(10))  // Prints "[1, 2, 3, 4, 5]"

        // TODO:获取前几个
        print(numbers.prefix(2))  // Prints "[1, 2]"
        print(numbers.prefix(10))  // Prints "[1, 2, 3, 4, 5]"

        // TODO:分割元素,以2作为分割点,不包括2
        let line = "BLANCHE: I don't want realism. I want magic!"
        print(line.split(separator: " ")) // ["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]

        // TODO:切割数组,切割次数,s忽略空数组, 2,从前匹配两个空格,其他是一组
        let temp5 = line.split(maxSplits: 2, omittingEmptySubsequences: true) { (item) -> Bool in
            return item == " "
        }
        print(temp5) // ["BLANCHE:", "I", "don\'t want realism. I want magic!"]

        print( line.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)) // ["BLANCHE:", "I", "don\'t want realism. I want magic!"]

        // TODO:替换
        // TODO:范围替换
        var nums = [10, 20, 30, 40, 50]
        nums.replaceSubrange(1...3, with: repeatElement(1, count: 5))
        print(nums) // [10, 1, 1, 1, 1, 1, 50]
        nums.replaceSubrange(5...6, with: [100, 200])
        print(nums) // [10, 1, 1, 1, 1, 100, 200]
        nums.replaceSubrange(2...2, with: repeatElement(1000, count: 1))
        print(nums) // [10, 1, 1000, 1, 1, 100, 200]
        nums[2] = 2000
        print(nums) // [10, 1, 2000, 1, 1, 100, 200]

        // TODO: 从前往后第一个位置替换
        var students = ["Ben", "Ivy", "Jordell", "Maxime"]
        if let i = students.firstIndex(of: "Maxime") {
            students[i] = "Max"
        }
        print(students)     // Prints "["Ben", "Ivy", "Jordell", "Max"]"

        // TODO: 从后往前最后一个位置替换
        var students2 = ["Ben", "Ivy", "Jordell", "Ben", "Maxime"]
        if let i = students2.lastIndex(of: "Ben") {
            students2[i] = "Benjamin"
        }
        print(students2)  // Prints "["Ben", "Ivy", "Jordell", "Benjamin", "Max"]"

        // TODO:数组的不同
        print(students.difference(from: students2))
        let temp6 = students.difference(from: students2) { (objc, item) -> Bool in
            print(objc + item)
            return objc == item
        }
        print(temp6.forEach({ (item) in
            print(item)
        }))

        // TODO:一个数组是否是另个数组的开始
        let arr1 = [1, 2, 3]
        let arr2 = [1, 2, 3, 4, 5, 6, 7]
        print(arr2.starts(with: arr1))

        // TODO:数组相等
        print([1, 2, 3].elementsEqual([2, 3, 4]))

        // TODO:数组包含
        print([1, 2, 3].contains(1))

        // TODO:最小值
        print(students2.min()!)
        // TODO:最大值
        print(students2.max()!)

        // TODO:升排序
        print([3, 2, 1, 4, 5, 2].sorted())
        // TODO:降序
        print([3, 2, 1, 4, 5, 2].sorted(by: { (a, b) -> Bool in
            a > b
        }))
    }

    /// 数组的高阶函数
    func demo2() {

        let possibleNumbers = ["1", "2", "three", "///4///", "5"]
        // MARK: map,可以对数组中的每一个元素做一次处理
        let arr = ["ddk", "asd", "cmd", "sd", "lp"]
        let arr2 = arr.map { (item) -> Bool in
            return item.contains("a")
        }
        print(arr2)

        let numbers = [1, 2, 3, 4]
        let mapped = numbers.map {
            Array(repeating: $0, count: $0)
        }
        print(mapped)   // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]

        // MARK: 非空判断, map可能存在空值,  flatMap确定类型
        let mapped2: [Int?] = possibleNumbers.map {
            str in Int(str)
        } // [1, 2, nil, nil, 5]
        print(mapped2)

        // MARK: flatMap, 可以对数组中的每一个元素做一次处理,并且不存在空值
        let arr3 = arr.flatMap { (item) -> [String] in
            return [item + "_js"]
        }
        print(arr3)

        let flatMapped = numbers.flatMap {
            Array(repeating: $0, count: $0)
        }
        print(flatMapped) // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]

        let test = [1, 2, 3, 4, 5]
        let result = test.flatMap({ (value) -> [String] in
            return [String(value), String(value * 5)]
        })
        print(result)

         // MARK: 一维转二维
        let test2 = [1, 2, 3, 4, 5]
        let result2 = test2.flatMap({ (value) -> [[String]] in
            return [[String(value), String(value * 5)]]
        })
        print(result2)

         // MARK: 多维转一维
        let array = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        print(array.flatMap({ $0 }))

        // 过滤nil
        let compactMapped: [Int] = possibleNumbers.compactMap {
            str in Int(str)
        } // [1, 2, 5]
        print(compactMapped)

         // MARK: 叠加值
        let res = test2.reduce(1000) { (objc, item) -> Int in
            return objc + item
        }
        print(res) // 1015

         // MARK: 过滤元素
        let res2 = possibleNumbers.filter { (objc) -> Bool in
            return Int(objc) != nil
        }
        print(res2)

        // MARK: - 包含
        let res3 = possibleNumbers.contains { (objc) -> Bool in
            return objc == "5"
        }
        print(res3)

    }

}

extension UIViewController {
    func testMuArr() {
        var mA = NSMutableArray(array: [1, 2, 3])
        var mB = mA
        mB.add(4)
        print(mA)
        print(mB)

        var mC = ["A", "B", "C"]
        var mD = mC
        mD.append("D")
        print(mC)
        print(mD)

        let testA = mC.map { (objc) -> Bool in
            return objc == "D"
        }
    }

}
