//
//  ViewController.swift
//  UIImagePickerControllerDemo
//
//  Created by 山神 on 2019/11/1.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    let temp = TakePhotoManager()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func openCamera(_ sender: UIButton) {

        temp.takePhoto(controller: self, isFront: true, isShowMask: true, didFinishPickBlock: { (image) in
            self.imageView.image = image
        }) {

        }
    }

}

