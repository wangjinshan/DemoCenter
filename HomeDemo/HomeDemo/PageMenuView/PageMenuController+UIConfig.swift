
//
//  PageMenuController+UIConfig.swift
//  HomeDemo
//
//  Created by 山神 on 2019/7/11.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

extension PageMenuController {
    func configurePageMenu(options: [PageMenuControllerOption]) {
        for option in options {
            switch (option) {
            case let .menuHeight(value):
                configuration.menuHeight = value
            case let .menuBackgroundColor(value):
                configuration.menuBackgroundColor = value
            case let .indicatorTopMargin(value):
                configuration.indicatorTopMargin = value
            case let .indicatorWidthBasedOnTitleTextWidth(value):
                configuration.indicatorWidthBasedOnTitleTextWidth = value
            case let .enableHorizontalBounce(value):
                configuration.enableHorizontalBounce = value
            case let .customLayoutMenuView(value):
                configuration.customLayoutMenuView = value
            case let .menuItemLeftMargin(value):
                configuration.menuItemLeftMargin = value
            case let .menuItemMargin(value):
                configuration.menuItemMargin = value
            case let .menuItemWidth(value):
                configuration.menuItemWidth = value
            case let .scrollAnimationDurationOnMenuItemTap(value):
                configuration.scrollAnimationDurationOnMenuItemTap = value
            case let .unselectedMenuItemLabelFont(value):
                configuration.unselectedMenuItemLabelFont = value
            case let .unselectedMenuItemLabelColor(value):
                configuration.unselectedMenuItemLabelColor = value
            case let .selectedMenuItemLabelFont(value):
                configuration.selectedMenuItemLabelFont = value
            case let .selectedMenuItemLabelColor(value):
                configuration.selectedMenuItemLabelColor = value
            case let .viewBackgroundColor(value):
                configuration.viewBackgroundColor = value
            case let .selectionIndicatorColor(value):
                configuration.selectionIndicatorColor = value
            case let .selectionIndicatorHeight(value):
                configuration.selectionIndicatorHeight = value
            case let .selectionIndicatorWidth(value):
                configuration.selectionIndicatorWidth = value
            }
        }
    }
}

extension PageMenuController:UIGestureRecognizerDelegate {
    func createUI()  {
        menuScrollView.isPagingEnabled = false
        menuScrollView.alwaysBounceHorizontal = configuration.enableHorizontalBounce
        menuScrollView.bounces = configuration.enableHorizontalBounce
        menuScrollView.showsHorizontalScrollIndicator = false
        menuScrollView.showsVerticalScrollIndicator = false
        menuScrollView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: configuration.menuHeight)
        menuScrollView.backgroundColor =  configuration.menuBackgroundColor
        menuScrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(menuScrollView)
        
        controllerScrollView.isPagingEnabled = true
        controllerScrollView.alwaysBounceHorizontal = configuration.enableHorizontalBounce
        controllerScrollView.bounces = configuration.enableHorizontalBounce
        controllerScrollView.showsHorizontalScrollIndicator = false
        controllerScrollView.showsVerticalScrollIndicator = false
        controllerScrollView.frame = CGRect(x: 0, y: configuration.menuHeight, width: view.frame.width, height: view.frame.height)
        controllerScrollView.backgroundColor = configuration.viewBackgroundColor
        view.addSubview(controllerScrollView)
        controllerScrollView.delegate = self
        controllerScrollView.contentInsetAdjustmentBehavior = .never
        
        configMenuItem()
        
        for item in menuItems {
            menuScrollView.addSubview(item)
            menuItemWidths.append(item.config.menuItemWidth)
        }
        setMenuItemLayout()
        
        let menuItemTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PageMenuController.handleMenuItemTap(_:)))
        menuItemTapGestureRecognizer.numberOfTapsRequired = 1
        menuItemTapGestureRecognizer.numberOfTouchesRequired = 1
        menuItemTapGestureRecognizer.delegate = self
        menuScrollView.addGestureRecognizer(menuItemTapGestureRecognizer)

        var selectionIndicatorFrame : CGRect = CGRect()
        if !(menuItems.count > 0)  {return}
        selectionIndicatorFrame = CGRect(x: 0, y: configuration.menuHeight - configuration.selectionIndicatorHeight, width: menuItems.first!.config.menuItemWidth, height: configuration.selectionIndicatorHeight)
        selectionIndicatorView = UIView(frame: selectionIndicatorFrame)
        selectionIndicatorView.backgroundColor = configuration.selectionIndicatorColor
        selectionIndicatorView.center.x = menuItems.first!.center.x
        menuScrollView.addSubview(selectionIndicatorView)
    }
    
    func configMenuItem()  {
        if controllerArray.isEmpty {return}
        let firstVc = controllerArray.first
        firstVc?.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        controllerScrollView.addSubview(firstVc!.view)
        addChild(firstVc!)
        if menuItems.isEmpty {return}
        for (index,item) in menuItems.enumerated() {
            if index == 0   {
                item.configureSelectedState(config: item.config)
            }else{
                item.configureNormalState(config: item.config)
            }
        }
    }
    
    func setScrollViewContent() {
        controllerScrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(controllerArray.count), height: view.frame.height - configuration.menuHeight)
        if configuration.customLayoutMenuView {
            var menuContentW:CGFloat = 0.0
            let margin = CGFloat(menuItems.count - 1) * configuration.menuItemMargin
            for item in menuItems {
                menuContentW += item.config.menuItemWidth
            }
            menuScrollView.contentSize = CGSize(width: (configuration.menuItemLeftMargin * 2.0)  + menuContentW +  margin, height: 0)
        }
    }
    
    func setMenuItemLayout() {
        for (index,item) in menuItems.enumerated() {
            if index == 0{
                item.frame.origin.x = configuration.menuItemLeftMargin
                menuScrollView.addSubview(item)
            }else {
                item.frame.origin.x =  menuItems[index - 1].frame.maxX + configuration.menuItemMargin
                menuScrollView.addSubview(item)
            }
        }
    }
}




