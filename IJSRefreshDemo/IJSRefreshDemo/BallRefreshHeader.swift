//
//  BallRefreshHeader.swift
//  IJSRefreshDemo
//
//  Created by 山神 on 2019/9/19.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit
import MJRefresh

class BallRefreshHeader: MJRefreshHeader {

    let ballView = RefreshAnimationView(frame: CGRect(x: 0, y: 0, width: 50, height: 48))

    override func prepare() {
        super.prepare()
        mj_h = 58
    }

    override func placeSubviews() {
        super.placeSubviews()
        ballView.frame = CGRect(x: 0, y: 0, width: 50, height: 48)
        ballView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        addSubview(ballView)
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

    override var pullingPercent: CGFloat {
        didSet {
            if state == MJRefreshState.refreshing { return }
            if 0.5 < pullingPercent, pullingPercent < 1.0 {
                let offset = (pullingPercent - 0.5) * ballView.distance / (0.5)
                ballView.pullingPercent = offset
                print(offset)
            }
        }
    }
}
