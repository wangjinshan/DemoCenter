//
//  JMMainViewController.swift
//  FormDemo
//
//  Created by 山神 on 2019/5/28.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit
import SnapKit

class JMMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan

        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 80, height: 80))
        imageView.backgroundColor = UIColor.red
        imageView.image = UIImage(named: "1999")
        view.addSubview(imageView)

        let mainPath = UIBezierPath()
        mainPath.move(to: CGPoint(x: 40, y: 0)) // 开始绘制，表示这个点是起点
        mainPath.addLine(to: CGPoint(x: 40, y: 100))
  //      mainPath.removeAllPoints() //删除所有点和线
        let ddk  = RingView()
//        ddk.frame = CGRect(x: 100, y: 300, width: 80, height: 80)
        ddk.backgroundColor = UIColor.green
        view.addSubview(ddk)
        ddk.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(300)
            make.width.height.equalTo(80)
        }

        ddk.imageView.image = UIImage(named: "1999")

    }

}

class RingView: UIView {

    let ringWidth: CGFloat = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(ringWidth)
            make.right.bottom.equalTo(-ringWidth)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let width = frame.size.width
        let height = frame.size.height

        let path = UIBezierPath()
        path.usesEvenOddFillRule = false
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(withCenter: CGPoint(x: width / 2.0, y: height / 2.0 ), radius: width / 2.0, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(withCenter: CGPoint(x: width / 2.0, y: height / 2.0 ), radius: width - ringWidth, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        UIColor.white.set()
        path.fill()
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 38
        imageView.layer.masksToBounds = true
        return imageView
    }()
}

// let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
// button.backgroundColor = UIColor.red
// button.alpha = 0.5
// view.addSubview(button)
//
// let label = UILabel(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
// label.text = "这是按钮"
// label.backgroundColor = UIColor.red
// label.layer.shouldRasterize = true
// button.addSubview(label)

//        let tagView = TagListView()
//        view.addSubview(tagView)
//
//        tagView.addTag("AHHHHH")
//        tagView.addTag("AHHDEKW")
//        tagView.addTag("OWEJFOWB")
//        tagView.snp.makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.right.equalTo(20)
//            make.top.equalTo(100)
//        }
//        tagView.marginX = 33
