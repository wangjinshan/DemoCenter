//
//  TakePhotoManager.swift
//  UIImagePickerControllerDemo
//
//  Created by 山神 on 2019/11/1.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class TakePhotoManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var didFinishPickBlock:((_ image: UIImage?) -> Void)?
    var didCancelBlock:(() -> Void)?
    func takePhoto(controller: UIViewController, isFront: Bool = false, isShowMask: Bool = false, didFinishPickBlock:((_ image: UIImage?) -> Void)?, didCancelBlock:(() ->Void)?) {
        let sourceType: UIImagePickerController.SourceType = .camera
        self.didFinishPickBlock = didFinishPickBlock
        self.didCancelBlock = didCancelBlock
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.sourceType = sourceType
            if isFront, UIImagePickerController.isCameraDeviceAvailable(.front){
                imagePicker.cameraDevice = .front
            }
            if isShowMask {
                let overView = UIImageView(image: UIImage(named: "1999"))
                overView.center = imagePicker.view.center
                imagePicker.cameraOverlayView = overView
            }
            controller.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancelBlock?()
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            didFinishPickBlock?(image)
        } else {
            didCancelBlock?()
        }
         picker.dismiss(animated: true, completion: nil)
    }
}
