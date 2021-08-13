//
//  AppDelegate.swift
//  FormDemo
//
//  Created by 山神 on 2019/5/28.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let vc = JMMainViewController()
        let navc = UINavigationController(rootViewController: vc)

        window?.rootViewController = navc

        let str = "http://www.baidu.com\n\nhttp://www.mob.com"

        let characterSet = CharacterSet(charactersIn: "\n")

        let temp = str.trimmingCharacters(in: characterSet)

        let str1 = " Hello \nhttp"

        let str2 = str1.trimmingCharacters(in: .whitespacesAndNewlines)

        return true
    }

}
