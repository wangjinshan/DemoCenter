//
//  CustomRefreshFooterView.swift
//  blackboard
//
//  Created by 山神 on 2019/8/14.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit
import MJRefresh

class BallRefreshFooterView: MJRefreshAutoFooter {

    let ballView = BallRoatationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 10))

    override func prepare() {
        super.prepare()
        mj_h = 86
    }

    override func placeSubviews() {
        super.placeSubviews()
        ballView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 10)
        ballView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        addSubview(ballView)
        ballView.moveLeft(offSet: ballView.distance)
        ballView.moveRight(offSet: ballView.distance)
    }

    override var state: MJRefreshState {
        didSet {
            switch state {
            case .refreshing:
                ballView.startAnimation()
            default:
                ballView.stopAnimation()
                break
            }
        }
    }
}
