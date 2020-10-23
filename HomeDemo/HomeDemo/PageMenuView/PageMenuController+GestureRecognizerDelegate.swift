
//
//  PageMenuController+GestureRecognizerDelegate.swift
//  HomeDemo
//
//  Created by 山神 on 2019/7/14.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit

extension PageMenuController {
    
    @objc func handleMenuItemTap(_ gestureRecognizer : UITapGestureRecognizer) {
        let tappedPoint : CGPoint = gestureRecognizer.location(in: menuScrollView)
        if tappedPoint.y < menuScrollView.frame.height {
            var itemIndex : Int = 0
            var menuItemLeftBound : CGFloat = 0.0
            var menuItemRightBound : CGFloat =  configuration.menuItemLeftMargin + menuItemWidths[0]  + (configuration.menuItemMargin / 2)
            if !(tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound) {
                for i in 1...controllerArray.count - 1 {
                    menuItemLeftBound = menuItemRightBound + 1.0
                    menuItemRightBound = menuItemLeftBound + menuItemWidths[i] + configuration.menuItemMargin
                    
                    if tappedPoint.x >= menuItemLeftBound && tappedPoint.x <= menuItemRightBound {
                        itemIndex = i
                        break
                    }
                }
            }
            
            if itemIndex >= 0 && itemIndex < controllerArray.count {
                if itemIndex != currentPageIndex {
                    startingPageForScroll = itemIndex
                    lastPageIndex = currentPageIndex
                    currentPageIndex = itemIndex
                    didTapMenuItemToScroll = true
                    let smallerIndex : Int = lastPageIndex < currentPageIndex ? lastPageIndex : currentPageIndex
                    let largerIndex : Int = lastPageIndex > currentPageIndex ? lastPageIndex : currentPageIndex
                    
                    if smallerIndex + 1 != largerIndex {
                        for index in (smallerIndex + 1)...(largerIndex - 1) {
                            if pagesAddedDictionary[index] != index {
                                addPageAtIndex(index)
                                pagesAddedDictionary[index] = index
                            }
                        }
                    }
                    addPageAtIndex(itemIndex)
                    pagesAddedDictionary[lastPageIndex] = lastPageIndex
                }
                let duration : Double = Double(configuration.scrollAnimationDurationOnMenuItemTap) / Double(1000)
                
                UIView.animate(withDuration: duration, animations: { () -> Void in
                    let xOffset : CGFloat = CGFloat(itemIndex) * self.controllerScrollView.frame.width
                    self.controllerScrollView.setContentOffset(CGPoint(x: xOffset, y: self.controllerScrollView.contentOffset.y), animated: false)
                })
                if tapTimer != nil {
                    tapTimer!.invalidate()
                }
                let timerInterval : TimeInterval = Double(configuration.scrollAnimationDurationOnMenuItemTap) * 0.001
                tapTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(PageMenuController.scrollViewDidEndTapScrollingAnimation), userInfo: nil, repeats: false) 
            }
        }
    }
}
