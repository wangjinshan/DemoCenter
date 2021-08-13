//
//  UIDemo.swift
//  SwiftDemo
//
//  Created by shan on 2021/6/2.
//  Copyright © 2021 山神. All rights reserved.
//

import UIKit

// MARK: 带箭头的view
class GuideTriangleView: UIView {

    public var edgeMargin: CGFloat = 0
    public var addTriangle = true
    public var directionType: DirectionEnum = .bottom
    public var tipHeight: CGFloat = 4
    public var tipWidth: CGFloat = 10

    enum DirectionEnum {
        case top
        case left
        case right
        case bottom
    }

    init(edgeMargin: CGFloat = 300, directionType: DirectionEnum = .bottom) {
        self.edgeMargin = edgeMargin
        self.directionType = directionType
        super.init(frame: .zero)
        backgroundColor = UIColor.blue
        layer.cornerRadius = 8
        setupLayerShadow(layer: layer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !addTriangle { return }
        let bezier = UIBezierPath()
        let height = bounds.size.height
        let width = bounds.size.width
        switch directionType {
        case .bottom:
            bezier.move(to: CGPoint(x: edgeMargin, y: height))
            bezier.addLine(to: CGPoint(x: edgeMargin + tipWidth / 2, y: height + tipHeight))
            bezier.addLine(to: CGPoint(x: edgeMargin + tipWidth, y: height))
        case .top:
            bezier.move(to: CGPoint(x: edgeMargin, y: 0))
            bezier.addLine(to: CGPoint(x: edgeMargin + tipWidth / 2, y: -tipHeight))
            bezier.addLine(to: CGPoint(x: edgeMargin + tipWidth, y: 0))
        case .left:
            bezier.move(to: CGPoint(x: 0, y: edgeMargin))
            bezier.addLine(to: CGPoint(x: -tipHeight, y: edgeMargin + tipWidth / 2))
            bezier.addLine(to: CGPoint(x: 0, y: edgeMargin + tipWidth))
        case .right:
            bezier.move(to: CGPoint(x: width, y: edgeMargin))
            bezier.addLine(to: CGPoint(x: width + tipHeight, y: edgeMargin + tipWidth / 2))
            bezier.addLine(to: CGPoint(x: width, y: edgeMargin + tipWidth))
        }
        layer.addSublayer(getShapeLayer(bezier: bezier))
    }

    private func getShapeLayer(bezier: UIBezierPath) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        lineLayer.lineWidth = 1
        lineLayer.strokeColor = UIColor.blue.cgColor
        lineLayer.path = bezier.cgPath
        lineLayer.fillColor = UIColor.blue.cgColor
        setupLayerShadow(layer: lineLayer)
        return lineLayer
    }

    private func setupLayerShadow(layer: CALayer) {
        layer.shadowColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
    }
}

