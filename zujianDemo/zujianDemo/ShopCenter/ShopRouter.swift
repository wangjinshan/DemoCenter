//
//  ShopRouter.swift
//  zujianDemo
//
//  Created by 山神 on 2020/7/24.
//  Copyright © 2020 山神. All rights reserved.
//

import UIKit

import ZRouter
import ZIKRouter.Internal

class ShopRouter: ZIKViewRouter<ShopController, ZIKViewRouteConfiguration> {

    override class func registerRoutableDestination() {
        registerExclusiveView(ShopController.self)
        register(RoutableView<ShopInput>())
    }

    override func destination(with configuration: ViewRouteConfig) -> ShopController? {
        let controller = ShopController()
        return controller
    }

    override func prepareDestination(_ destination: ShopController, configuration: ZIKViewRouteConfiguration) {
        destination.name = "1999"

    }
}

@objc protocol ShopInput: ZIKViewRoutable {

}

extension ShopController: ZIKRoutableView, ShopInput {

}
