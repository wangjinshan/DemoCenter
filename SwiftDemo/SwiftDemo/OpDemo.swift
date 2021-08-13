//
//  OpDemo.swift
//  SwiftDemo
//
//  Created by 山神 on 2019/7/9.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

// 隐士可选型
class OpDemo: NSObject {
}

class City {
    let cityName: String
  unowned  var country: Country
    init(cityName: String, country: Country) {
        self.cityName = cityName
        self.country = country
    }
}

class Country {
    let countryName: String
    var capitalCity: City!
    init(countryName: String, capitalCity: String) {
        self.countryName = countryName
        self.capitalCity = City(cityName: capitalCity, country: self)
    }
}
// 意义: 暂时可以为null,真正使用的时候就是 具体值
