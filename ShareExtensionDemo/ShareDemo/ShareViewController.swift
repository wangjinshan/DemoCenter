//
//  ShareViewController.swift
//  ShareDemo
//
//  Created by 山神 on 2019/5/31.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    /// 点击了提交
    override func didSelectPost() {
        let item = extensionContext?.inputItems.first
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    /// 点击了取消
    override func didSelectCancel() {
        super.didSelectCancel()
    }

}
