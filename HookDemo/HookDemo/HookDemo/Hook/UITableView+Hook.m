//
//  UITableView+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/10.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UITableView+Hook.h"
#import "RuntimeHelper.h"
#import "SAScrollViewDelegateProxy.h"

@implementation UITableView (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sel_exchangeFromSel:@selector(setDelegate:) toSel:@selector(hook_setDelegate:)];
    });
}

- (void)hook_setDelegate:(id<UITableViewDelegate>)delegate {
    //resolve optional selectors
    [SAScrollViewDelegateProxy resolveOptionalSelectorsForDelegate:delegate];
    
    [self hook_setDelegate:delegate];

    if (!delegate || !self.delegate) {
        return;
    }
    // 使用委托类去 hook 点击事件方法
    [SAScrollViewDelegateProxy proxyDelegate:self.delegate selectors:[NSSet setWithArray:@[@"tableView:didSelectRowAtIndexPath:"]]];
}

@end
