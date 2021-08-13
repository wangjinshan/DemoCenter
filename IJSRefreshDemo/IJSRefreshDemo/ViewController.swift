//
//  ViewController.swift
//  IJSRefreshDemo
//
//  Created by 山神 on 1819/9/19.
//  Copyright © 1819 山神. All rights reserved.
//

import UIKit
import MJRefresh

enum FontType: Int {
    case regular
    case light
    case medium
    case semibold
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        tableView.mj_header = BallRefreshHeader(refreshingBlock: {
           UIApplication.shared.openURL(URL(string: "weixin://")!)
        })

        tableView.mj_footer = BallRefreshFooterView(refreshingBlock: {

        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            //  self.tableView.mj_header.endRefreshing()
        })

    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.cyan
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
