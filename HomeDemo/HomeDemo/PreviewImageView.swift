//
//  PreviewImageView.swift
//  blackboard
//
//  Created by 山神 on 2019/7/21.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit

class PreviewImageView: UIView, UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }

    let topMargin: CGFloat = 5.0
    let leftMargin: CGFloat = 30.0
    let lineMargin: CGFloat = 5.0
    let itemHeight: CGFloat = 100.0

    init(frame: CGRect, imagesUrl: [String]) {
        super.init(frame: frame)
//        addSubview(imageContentView)
//         imageContentView.imageUrls = imagesUrl
        let itemWidth =  CGFloat(((frame.size.width - leftMargin * 2) - 2 * lineMargin)) / 3.0
//        imageContentView.snp.makeConstraints { (make) in
//            make.top.equalTo(topMargin)
//            make.left.equalTo(leftMargin)
//            make.right.equalTo(-leftMargin)
//        }
        let layout = HorizontalPageFlowlayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = topMargin
        layout.minimumInteritemSpacing = topMargin

        let temp  = UICollectionViewFlowLayout()
        temp.itemSize = CGSize(width: 100, height: 100)


        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 375, height: 250), collectionViewLayout:  layout)
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)

        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HorizontalPageFlowlayout: UICollectionViewLayout {
    var minimumLineSpacing: CGFloat = 10
    var minimumInteritemSpacing: CGFloat = 10
    var itemSize: CGSize = CGSize(width: 100, height: 100)
    var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    var line: Int = 2
    var item: Int = 3
    var pageNumber: Int = 1
    var itemSpacing: CGFloat = 10
    var lineSpacing: CGFloat = 10
    var attributes: [UICollectionViewLayoutAttributes] = []

    override func prepare() {
        super.prepare()
        let itemWidth: CGFloat = itemSize.width - 1
        let itemHeight: CGFloat = itemSize.height - 1

        let width: CGFloat = collectionView?.frame.size.width ?? 0
        let height: CGFloat = collectionView?.frame.size.height ?? 0

        let contentWidth: CGFloat = width - sectionInset.left - sectionInset.right
        if contentWidth >= (2 * itemWidth + minimumInteritemSpacing) {
            let tempLine = Int((contentWidth - itemWidth) / (itemWidth + minimumInteritemSpacing))
            item = tempLine + 1
            itemSpacing = minimumInteritemSpacing
        } else {
            itemSpacing = 0
        }

        let contentHeight: CGFloat = height - sectionInset.top - sectionInset.bottom
        if contentHeight >= (2 * itemHeight + minimumLineSpacing) {
            let m = Int((contentHeight - itemHeight) / (itemHeight + minimumLineSpacing))
            line = m + 1
            lineSpacing = minimumLineSpacing
        } else {
            lineSpacing = 0
        }

        var itemNumber: Int = 0
        if let collectionView = collectionView {
            itemNumber  = (itemNumber + Int(collectionView.numberOfItems(inSection: 0)))
        }
        pageNumber = (itemNumber - 1) / (line * item) + 1
    }

    override var collectionViewContentSize: CGSize {
        let width = collectionView?.bounds.size.width ?? 0
        let height = collectionView?.bounds.size.height ?? 0
        return CGSize(width: width * CGFloat(pageNumber), height: height)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var frame: CGRect = CGRect.zero
        frame.size = itemSize
        let onePagenumber: Int = line * item
        var lineNumber: Int = 0
        var page: Int = 0
        if indexPath.item >= onePagenumber {
            page = indexPath.item / onePagenumber
            lineNumber = (indexPath.item % onePagenumber) / item
        } else {
            lineNumber = indexPath.item / item
        }
        let lineIndex: Int = indexPath.item % item
        if let collectionView = collectionView {
            let x = CGFloat(lineIndex) * itemSize.width + CGFloat(lineIndex) * itemSpacing + sectionInset.left + CGFloat((indexPath.section + page)) * collectionView.frame.size.width
            let y = CGFloat(lineNumber) * itemSize.height + CGFloat(lineNumber) * lineSpacing + sectionInset.top
            frame.origin = CGPoint(x: x, y: y )
        }
        attribute.frame = frame
        return attribute
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var tmpAttributes = [UICollectionViewLayoutAttributes]()
        guard let collectionView = collectionView else {
            return tmpAttributes
        }

        for j in 0..<collectionView.numberOfSections {
            let count = collectionView.numberOfItems(inSection: j)
            for i in 0..<count {
                let indexPath = IndexPath(item: i, section: j)
                if let temp  = layoutAttributesForItem(at: indexPath) {
                    tmpAttributes.append(temp)
                }
            }
            attributes = tmpAttributes
        }
        return attributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView  else { return CGPoint.zero }
        var offsetY: CGFloat = CGFloat(MAXFLOAT)
        var offsetX: CGFloat = CGFloat(MAXFLOAT)
        let horizontalCenter: CGFloat = proposedContentOffset.x + itemSize.width / 2
        let verticalCenter: CGFloat = proposedContentOffset.y + itemSize.height / 2
        let targetRect = CGRect(x: 0, y: 0.0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let array = super.layoutAttributesForElements(in: targetRect)

        var offPoint: CGPoint = proposedContentOffset
        if let array = array {
            for layoutAttributes in array {
                let itemHorizontalCenter: CGFloat = layoutAttributes.center.x
                let itemVerticalCenter: CGFloat = layoutAttributes.center.y

                if (abs(itemHorizontalCenter - horizontalCenter) != 0) && (abs(offsetX) > abs(itemHorizontalCenter - horizontalCenter)) {
                    offsetX = itemHorizontalCenter - horizontalCenter
                    offPoint = CGPoint(x: itemHorizontalCenter, y: itemVerticalCenter)
                }
                if (abs(itemVerticalCenter - verticalCenter) != 0) && (abs(offsetY) > abs(itemVerticalCenter - verticalCenter)) {
                    offsetY = itemHorizontalCenter - horizontalCenter
                    offPoint = CGPoint(x: itemHorizontalCenter, y: itemVerticalCenter)
                }
            }
        }
        return offPoint
    }

    func shouldinvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        print(newBounds)
        return true
    }
    
}
