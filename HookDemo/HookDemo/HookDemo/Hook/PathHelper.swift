//
//  PathHelper.swift
//  blackboard
//
//  Created by roni on 2018/12/7.
//  Copyright © 2018 xkb. All rights reserved.
//

import Foundation
import UIKit
import LogicBehind
import HUD

class PathHelper: NSObject {

    class func getClassTypeAndKey(sender: Any) -> (name: String, key: String) {
        let name = String(describing: object_getClass(sender) ?? UIViewController.self)
        let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
        let key = nameSpace + "." + name
        return (name, key)
    }

    @objc class func getClassName(sender: Any) -> String {
        if let obj = object_getClass(sender) {
            return String(describing: obj)
        }
        return ""
    }

    @objc class func getTitle(sender: Any) -> String {
        func getText(sender: Any) -> String? {
            if let label = sender as? UILabel {
                return label.text ?? ""
            }
            if let button = sender as? UIButton {
                if let buttonTitle = button.title(for: .normal) {
                    return buttonTitle
                } else if button.image(for: .normal) != nil {
                    return "图片按钮"
                }
            }
            return nil
        }
        if let barItem = sender as? UIBarItem {
            return barItem.title ?? ""
        }
        if let text = getText(sender: sender) {
            return text
        }
        if let view = sender as? UIView {
            for item in view.subviews {
                if let text = getText(sender: item) {
                    return text
                }
            }
        }
        return ""
    }

    @objc class func getDesc(sender: Any) -> String {
        var desc = getClassName(sender: sender)
        if let view = sender as? UIView {
            if let index = view.superview?.subviews.firstIndex(of: view) {
                desc += "[\(index)]"
            }
        }
        return desc
    }

    @objc class func isSystem(sender: Any) -> Bool {
        if getClassName(sender: sender).contains("_") {
            return false
        }
        return true
    }

//    @objc class func getTopWindow() -> UIWindow {
//        let windows = UIApplication.shared.windows
//        var topWindow = UIWindow()
//        topWindow.windowLevel = UIWindow.Level(rawValue: -1)
//        for window in windows where !window.isHidden && window.windowLevel > topWindow.windowLevel {
//            if let keyboardWindow = NSClassFromString("UITextEffectsWindow"), window.isKind(of: keyboardWindow) {
//                continue
//            } else {
//                topWindow = window
//            }
//        }
//        return topWindow
//    }

    class func takeScreenshot() -> UIImage? {
        var imageSize = CGSize.zero
        let screenSize = UIScreen.main.bounds.size
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait {
            imageSize = screenSize
        } else {
            imageSize = CGSize(width: screenSize.height, height: screenSize.width)
        }
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        if let context = context {
            for window in UIApplication.shared.windows {
                context.saveGState()
                context.translateBy(x: window.center.x, y: window.center.y)
                context.concatenate(window.transform)
                context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
                if orientation == .landscapeLeft {
                    context.rotate(by: .pi/4)
                    context.translateBy(x: 0, y: -imageSize.width)
                } else if orientation == .landscapeRight {
                    context.rotate(by: -.pi/2)
                    context.translateBy(x: -imageSize.height, y: 0)
                } else if orientation == .portraitUpsideDown {
                    context.rotate(by: .pi)
                    context.translateBy(x: -imageSize.width, y: -imageSize.height)
                }
                if window.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
                    window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
                } else {
                    window.layer.render(in: context)
                }
                context.restoreGState()
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func takeScreenshotWithoutHookView() -> UIImage? {
        HUD.hide()
        DisplayViewManager.sharedInstance.isHidden = true
        let image = takeScreenshot()
        DisplayViewManager.sharedInstance.isHidden = false
        return image
    }

    @objc class func getTopWindowRootView() -> UIView? {
        if let window = UIApplication.shared.windows.last(where: { (window) -> Bool in
            var isSystem = false
            if let remoteKeyboardWindow = NSClassFromString("UIRemoteKeyboardWindow"), window.isKind(of: remoteKeyboardWindow) {
                isSystem = true
            }
            if let textEffectsWindow = NSClassFromString("UITextEffectsWindow"), window.isKind(of: textEffectsWindow) {
                isSystem = true
            }
            return !window.isHidden && !isSystem
        }) {
            return window.rootViewController?.view
        }
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
           return rootViewController.view
        }
        return nil
    }

    @objc class func getTopViewController() -> UIViewController? {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController,
            let visibleViewController = getVisibleViewController(from: rootViewController) {
            return visibleViewController
        }
        return nil
    }

    @objc class func getTopViewControllerName() -> [String: String] {
        if let topViewController = getTopViewController() {
            return ["componentName": getClassName(sender: topViewController), "componentTitle": topViewController.title ?? ""]
        }
        return ["componentName": "", "componentTitle": ""]
    }

    // 控件名单
    static let subControllerList = ["AlertController", "SelectSubjectViewController", "SelectGradeViewController", "SelectPageViewController"]

    // 判断是否是控件(原则present出来的页面在控件名单里)
    class func isSubController(viewController: UIViewController) -> Bool {
        func subFunc(vc: UIViewController) -> Bool {
            var result = false
            let name = getClassName(sender: vc)
            subControllerList.forEach { (text) in
                if name.contains(text) {
                    result = true
                }
            }
            return result
        }
        if subFunc(vc: viewController) {
            return true
        }
        if let nav = viewController as? UINavigationController, nav.viewControllers.count == 1 {
            let vc = nav.viewControllers[0]
            return subFunc(vc: vc)
        }
        return viewController.isPanModalPresented
    }

    class func getVisibleViewController(from rootViewController: UIViewController) -> UIViewController? {
        var resultViewController: UIViewController?
        if let nextResponser = rootViewController.presentedViewController {
            if isSubController(viewController: nextResponser) {
                return getPresentingViewController(baseViewController: rootViewController)
            }
            resultViewController = getVisibleViewController(from: nextResponser)
        } else if let tabBarViewController = rootViewController as? UITabBarController,
            let selectedViewController = tabBarViewController.selectedViewController {
            resultViewController = getVisibleViewController(from: selectedViewController)
        } else if let navigationController = rootViewController as? UINavigationController,
            let visibleVC = navigationController.topViewController?.visibleViewController {
            resultViewController = getVisibleViewController(from: visibleVC)
        } else {
            resultViewController = rootViewController
        }
        return resultViewController
    }

    // 如果是present出来的控件 寻找控件的父页面
    class func getPresentingViewController(baseViewController: UIViewController) -> UIViewController {
        var resultViewController: UIViewController
        if let tabBarViewController = baseViewController as? UITabBarController,
           let selectedViewController = tabBarViewController.selectedViewController {
            resultViewController = getPresentingViewController(baseViewController: selectedViewController)
        } else if let navigationController = baseViewController as? UINavigationController,
                  let visibleVC = navigationController.topViewController {
            resultViewController = getPresentingViewController(baseViewController: visibleVC)
        } else {
            resultViewController = baseViewController
        }
        return resultViewController
    }

    // 最上层的vc与相应的vc比较 如果相同则表示一个页面 如果不同则表示有子页面
    @objc class func getViewDesc(_ view: UIView) -> [String: String] {
        if let topViewController = getTopViewController() {
            let topName = getClassName(sender: topViewController)
            let vcName = getClassName(sender: view.getController())
            if topName == vcName {
                return ["componentName": topName,
                        "componentTitle": topViewController.title ?? "",
                        "subComponent": ""]
            }
            return ["componentName": topName,
                    "componentTitle": topViewController.title ?? "",
                    "subComponent": vcName]
        }
        return ["componentName": "", "componentTitle": "", "subComponent": ""]
    }

    @objc class func getControllerPath(from controller: UIViewController) -> String? {
        var parent = controller
        var responder: UIResponder = controller
        while parent == controller {
            guard let r = responder.next else { return nil }
            responder = r
            if let c = r as? UIViewController {
                guard let c1 = getVisibleViewController(from: c) else { return nil }
                parent = c1
            }
        }
        let path = getControllerPath(from: parent)
        let name = getClassName(sender: controller)
        return path == nil ? name : "\(path!)#\(name)"
    }
}
