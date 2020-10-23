//
//  PageMenuController+Option.swift
//  HomeDemo
//
//  Created by 山神 on 2019/7/11.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

public enum PageMenuControllerOption {
    case menuHeight(CGFloat)
    case menuBackgroundColor(UIColor)
    case indicatorTopMargin(CGFloat)
    case indicatorWidthBasedOnTitleTextWidth(Bool)
    case enableHorizontalBounce(Bool)
    case customLayoutMenuView(Bool)
    case menuItemLeftMargin(CGFloat)
    case menuItemMargin(CGFloat)
    case menuItemWidth(CGFloat)
    case unselectedMenuItemLabelFont(UIFont)
    case unselectedMenuItemLabelColor(UIColor)
    case selectedMenuItemLabelFont(UIFont)
    case selectedMenuItemLabelColor(UIColor)
    case scrollAnimationDurationOnMenuItemTap(Int)
    case viewBackgroundColor(UIColor)
    case selectionIndicatorColor(UIColor)
    case selectionIndicatorHeight(CGFloat)
    case selectionIndicatorWidth(CGFloat)
}

public enum PageMenuItemViewOption{
    case menuItemSelectedBackgroundColor(UIColor)
    case menuItemUnSelectedBackgroundColor(UIColor)
    case menuItemCornerRadius(CGFloat)
    case menuItemBottomMargin(CGFloat)
    case menuItemTitleIconMargin(CGFloat)
    case menuItemWidth(CGFloat)
    case menuItemHeight(CGFloat)
    case menuItemTitle(String)
    case menuItemIcon(String)
}

