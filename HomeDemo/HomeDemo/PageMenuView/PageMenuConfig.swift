//
//  PageMenuConfig.swift
//  HomeDemo
//
//  Created by 山神 on 2019/7/11.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

class PageMenuViewConfig {
    open var customLayoutMenuView:Bool = true
    open var menuItemLeftMargin : CGFloat = 15.0
    open var menuItemMargin : CGFloat = 44.0
    open var menuHeight:CGFloat = 34.0
    open var menuBackgroundColor = UIColor.green
    open var indicatorTopMargin:CGFloat = 5.0
    open var indicatorWidthBasedOnTitleTextWidth:Bool = true
    open var enableHorizontalBounce : Bool = true
    open var menuItemWidth : CGFloat = 66.0
    open var unselectedMenuItemLabelFont:UIFont = UIFont.systemFont(ofSize: 14)
    open var unselectedMenuItemLabelColor:UIColor = UIColor.black
    open var selectedMenuItemLabelFont:UIFont = UIFont.systemFont(ofSize: 17)
    open var selectedMenuItemLabelColor:UIColor = UIColor.red
    open var scrollAnimationDurationOnMenuItemTap:Int = 300
    open var viewBackgroundColor : UIColor = UIColor.orange
    open var selectionIndicatorColor: UIColor = UIColor.red
    open var selectionIndicatorHeight:CGFloat = 3.0
    open var selectionIndicatorWidth:CGFloat = 44.0
    
    init() {}
}

class PageMenuItemConfig {
    open var menuItemSelectedBackgroundColor:UIColor = UIColor.white
    open var menuItemUnSelectedBackgroundColor:UIColor = UIColor.white
    open var menuItemCornerRadius:CGFloat = 0
    open var menuItemBottomMargin:CGFloat = 5
    open var menuItemTitleIconMargin:CGFloat = 1
    open var menuItemWidth:CGFloat = 66.0
    open var menuItemHeight:CGFloat = 34.0
    open var menuItemTitle:String = ""
    open var menuItemIcon:String = ""
    
    open var unselectedMenuItemLabelFont:UIFont = UIFont.systemFont(ofSize: 14)
    open var unselectedMenuItemLabelColor:UIColor = UIColor.black
    open var selectedMenuItemLabelFont:UIFont = UIFont.systemFont(ofSize: 17)
   open var selectedMenuItemLabelColor:UIColor = UIColor.red
    
    init() {}
}



