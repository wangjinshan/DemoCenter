//
//  PhototViewController.swift
//  CustomPresentDemo
//
//  Created by 山神 on 2020/6/30.
//  Copyright © 2020 山神. All rights reserved.
//

import UIKit

class PhototViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "弹窗"
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissAction))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissAction() {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func pdfAction(_ sender: UIButton) {
        let vc = PDFViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
