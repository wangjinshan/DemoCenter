//
//  Demo.swift
//  SwiftDemo
//
//  Created by 山神 on 2019/7/8.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit


class Demo: NSObject {
    enum Theme {
        case Day
        case Night
    }
    let age = 19
    var errorCode:String? = nil
    var errorMessage:String? = "Not found"
    var error1:(errorCode:Int,errorMessage:String?) = (404,"Not Found")
    
    
    override init() {
    }
    private let text: Theme = .Day
    
    func loadName(theme : Theme) {
        switch age {
        case 10...19:
            break
        default:
            break
        }
        if case 10...19 = age, age >= 12 {
            
        }
        
        for case let i  in 1...100 where i % 3 == 0{
            print(i)
        }
        
        guard  theme == .Day else { return  }
        
        for c in "hello wjs" {
            print(type(of: c))
        }
        print(type(of: self))
        
        let str = "Hello, Swift"
        let startIndex = str.startIndex
        print(str[startIndex])
        print(str.prefix(5))
        
        demoStr()
        optionalDemo()
        var score1 = [11,33,55,22]
        changeScores(scores: &score1, by: changeScore1(score:))
        // map 根据条件进行处理
       var temp =  score1.map(changeScore)
        // 筛选
        var temp2 = score1.filter(fail)
        //聚合
       var temp3 = score1.reduce(0, +)
        
        
    }
}

extension Demo{
    
    convenience init(name: Theme) {
        self.init();
    }
    // 字符串
    func demoStr()  {
        var name = "我是中国人,我爱中国,wangjinshan"
        let startIndex = name.startIndex
        
        // 截取字符串从头开始
        let sub1 = name.prefix(20)
        print(sub1)
        //从后
        print(name.suffix(8))
        // 位置
        let str4 = name.substingInRange(0..<1)
        print("string from 4 - 6 : \(str4!)")
        // 前后
        print(name.lastIndex(of: "中") ?? "")
        // 分割
        print(name.split(separator: ","))
        // 替换
        print("空格替换成-:", name.replacingOccurrences(of: " ", with: "-"))
        // 过滤
        print("空格过滤掉:", name.replacingOccurrences(of: " ", with: ""))
        // 去首尾空格
        print("去掉空格:", name.trimmingCharacters(in: .whitespaces))
        // 分割
        print("分割:", name.components(separatedBy: ","))
        // 拼接
        let a = ["1", "2", "3"]
        print("拼接:", a.joined(separator: "-"))
        // 加
        print(name.appending("哈哈哈"))
        // 插入
        print(name.insert(contentsOf: "卧槽", at: name.index(startIndex, offsetBy: 3)))
        print(name)
        //删除
        let  endIndex = name.index(startIndex, offsetBy: 5)
        let  range = startIndex...endIndex
        name.removeSubrange(range)
        
        print("""
            关关雎鸠，在河之洲。
            窈窕淑女，君子好逑。
            参差荇菜，左右流之。
            窈窕淑女，寤寐求之。
            求之不得，寤寐思服。
            悠哉悠哉，辗转反侧。
            参差荇菜，左右采之。
            窈窕淑女，琴瑟友之。
            参差荇菜，左右芼之。
            窈窕淑女，钟鼓乐之。
            """)
        print(String(format: "%.2f", 2.0 / 3.0))
        Range(NSRange(location: 0, length: 2))
        
        print(name.range(of: "我")!)
    
    }
    
    func blockDemo(name: (_ block: String) -> (String)) {
        name("ahah")
    }
    
    func optionalDemo()  {
        errorCode = "404"
        if let errorCode = errorCode , errorCode == errorMessage, errorCode == "404"{

        }

        let arr = [1,2,3,4,5]
        for (index,value) in arr.enumerated() {
            print(index,value)
        }
        
        var user = ["name" : "山神"]
        // 更新
      var temp2 =  user.updateValue("啊哈哈哈", forKey: "name")
        var temp3  = user.removeValue(forKey: "name")
        user["ccc"] = "you qew "
    
        var someInt = 7
        var anotherInt = 107
        swapTwoInts(a: &someInt, b: &anotherInt)
    }
    
    func swapTwoInts( a:inout Int , b:inout Int) {
        let temp = a
        a = b
        b = temp
    }
    
    func changeScores( scores:inout [Int],by changeScore:(Int) -> Int) {
        for (index,score) in scores.enumerated() {
            scores[index] = changeScore(score);
        }
    }
    func changeScore1(score:Int) -> Int {
        return Int(sqrt(Double(score)) * 10)
    }
    func changeScore2(score:Int) -> Int {
        return Int(sqrt(Double(score)) * 150 * 100.0)
    }
    func changeScore(score:Int) -> Int {
        return Int(score * 10)
    }
    func fail(score:Int) -> Bool {
        return score < 60
    }
    func add(num1:Int,_ num2:Int) -> Int {
        return num1 + num2
    }
    
}

extension String {
    //获取子字符串
    func substingInRange(_ range: Range<Int>) -> String? {
        if range.lowerBound < 0 || range.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy:range.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:range.upperBound)
        return String(self[startIndex..<endIndex])
    }
    func startToEnd(start: Int,end: Int) -> String {
        if !(end < count) || start > end { return "取值范围错误" }
        var tempStr: String = ""
        for i in start...end {
            let temp: String = self[self.index(self.startIndex, offsetBy: i - 1)].description
            tempStr += temp
        }
        return tempStr
    }
    
}
