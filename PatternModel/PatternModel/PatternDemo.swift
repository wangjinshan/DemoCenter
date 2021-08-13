//
//  PatternDemo.swift
//  PatternModel
//
//  Created by 山神 on 2020/10/19.
//

import UIKit

// MARK: - 依赖倒置原则

/// 程序协议
protocol LanguageProtocol {
    func grammar()
}

/// 程序员协议
protocol ProgrammerProtocol {
    func programing(language: LanguageProtocol)
}

/// 程序员
class Programmer: ProgrammerProtocol {

    init(name: String) {
        print("\(name)")
    }

    func programing(language: LanguageProtocol) {
        language.grammar()
    }
}

/// 语言类
class OCLanguage: LanguageProtocol {
    func grammar() {
        print("编写OC语法")
    }
}

class JavaLanguage: LanguageProtocol {
    func grammar() {
        print("编写java语法")
    }
}

/// 使用
class Demo1 {

    func test1() {
        let oc = OCLanguage()
        let p1 = Programmer(name: "金山")
        p1.programing(language: oc)
    }
}

// MARK: - 接口隔离原则
// 例子:  HR 找优秀程序员

/// 好技术协议
protocol GoodProgramerAbilityProtocol {
    func goodPragramerAbility()
}

/// 成就客户
protocol GoodCustomerProtocol {
    func goodCustomer()
}

/// HR搜索协议
protocol HRSearchProtocol {
    func show()
}

/// 好程序员需要满足的条件,后面也是对这个类的扩充
class GoodPragrammer1: GoodProgramerAbilityProtocol, GoodCustomerProtocol {

    init(name: String) {
        print("\(name)")
    }

    func goodPragramerAbility() {
        print("好技术")
    }

    func goodCustomer() {
        print("成就客户")
    }
}

class GoodPragrammer2: GoodProgramerAbilityProtocol {

    init(name: String) {
        print("\(name)")
    }

    func goodPragramerAbility() {
        print("新程序员要求")
    }
}

/// 抽象HR类
class HRSearch: HRSearchProtocol {

    var goodAbility: GoodProgramerAbilityProtocol?
    var customer: GoodCustomerProtocol?

    init(name: String) {
        print("\(name)")
    }

    func show() {

    }

    func searchAbilityProgramer(programmer: GoodProgramerAbilityProtocol) {
        goodAbility = programmer
    }

    func searchCustomer(programmer: GoodCustomerProtocol) {
        customer = programmer
    }
}

/// 具体HR
class HRSearchInstance: HRSearch {
    override func show() {
        if let goodAbility = goodAbility {
            goodAbility.goodPragramerAbility()
        }
        if let customer = customer {
            customer.goodCustomer()
        }
    }
}

class Demo2 {

    class func test2() {
        let hr = HRSearchInstance(name: "HR")
        let pra1 = GoodPragrammer1(name: "金山")
        hr.searchAbilityProgramer(programmer: pra1)
        hr.searchCustomer(programmer: pra1)
        hr.show()
    }
}
