//
//  ViewController.swift
//  HookDemo
//
//  Created by shan on 2021/6/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        let demo = WJSDemo()
        UIApplication.shared.sendAction(#selector(test), to: demo, from: self, for: UIEvent())
        self.demo()
        createNewClass()
    }

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.register(DemoCell.self, forCellReuseIdentifier: "DemoCell")
        return table
    }()

    @objc func test() {
    }

    @objc private func demo(name: String = "家具是件大事") -> String {
        let objc = object_getClass(self)!
        let method = class_getInstanceMethod(objc, Selector(("viewDidLoad")))!
        let methodIMP = method_getImplementation(method)
        let types = method_getTypeEncoding(method)
        print(types)
        return name
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(10 * indexPath.row) / 255.0, green: CGFloat(5 * indexPath.row) / 255.0, blue: CGFloat(3 * indexPath.row) / 255.0, alpha: 1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class DemoCell: UITableViewCell {

}

class WJSDemo {
    @objc private func test() {
         print("-----哈哈哈哈-------")
     }
}

class ClassA {
    let name = "adasd"
    let age = 18

    class func demo() {

    }

    func demo() {

    }

    func viewDidLoad() {

    }

    class  func viewDidLoad() {

    }
}

class ClassB: ClassA {
    let ssk = "addas"
}

// MARK: - 动态创建一个类
class CreateNewClass {

}

extension ViewController {
    private func createNewClass() {
        let className = NSString(string: "WJS")
        let originalClass = object_getClass(self)!
        let subclass = objc_allocateClassPair(originalClass, className.utf8String!, 0)
        if (class_getInstanceSize(originalClass) != class_getInstanceSize(subclass)) {
            print("报错")
        }
        print(subclass)
    }
}

