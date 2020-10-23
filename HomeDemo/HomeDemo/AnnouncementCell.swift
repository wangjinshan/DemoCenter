//
//  AnnouncementCell.swift
//  blackboard
//
//  Created by 山神 on 2019/7/18.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit

class AnnouncementCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(titleLabel)
        backView.addSubview(contentLabel)
        backView.addSubview(contentImageView)
        backView.addSubview(timeLabel)
        backView.addSubview(readingImageView)
        backView.addSubview(readingNumLabel)

        backView.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        titleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(16)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleImageView.snp.bottom).offset(14)
            make.left.equalTo(15)
        }
        contentImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(-58)
            make.height.width.equalTo(76)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentImageView.snp.bottom).offset(-6)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.bottom.equalTo(-10)
        }
        readingImageView.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(44)
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.width.equalTo(44)
            make.height.equalTo(33)
        }
        readingImageView.snp.makeConstraints { (make) in
            make.left.equalTo(readingImageView.snp.right).offset(3)
            make.centerY.equalTo(timeLabel.snp.centerY)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.green
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.cyan
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    let readingImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let readingNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.orange
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
}

