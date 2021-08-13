//
//  UIViewController+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/7.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIViewController+Hook.h"
#import "RuntimeHelper.h"
//#import "blackboard-Swift.h"
//#import <XHBMars/Mars.h>


@implementation UIViewController (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sel_exchangeFromSel:@selector(viewDidLoad) toSel:@selector(hook_ViewDidLoad)];
        [self sel_exchangeFromSel:@selector(viewDidAppear:) toSel:@selector(hook_ViewDidAppear:)];
        [self sel_exchangeFromSel:@selector(viewWillDisappear:) toSel:@selector(hook_ViewWillDisappear:)];
        [self sel_exchangeFromSel:@selector(viewDidDisappear:) toSel:@selector(hook_ViewDidDisappear:)];
    });
}

- (void)hook_ViewDidLoad {
    if (![self isKindOfClass:[UINavigationController class]] && ![self isKindOfClass:[UITabBarController class]]) {
//        NSString *viewControllerName = [PathHelper getClassNameWithSender:self];
//        [SLMarsIO addCreateWithNSString:viewControllerName withNSString:nil];
    }
    [self hook_ViewDidLoad];
}

- (void)hook_ViewDidAppear:(BOOL)animated {
//    if (![self isKindOfClass:[UINavigationController class]] && ![self isKindOfClass:[UITabBarController class]]) {
        
//        NSString *viewControllerName = [PathHelper getClassNameWithSender:self];
//        [SLMarsIO getFocusWithNSString:viewControllerName withNSString:nil];
        
//        NSLog(@"UIViewController+Hook: viewControllerDidAppear: %@", viewControllerName);
        
//        if (![UIView isInBlackList: viewControllerName]) {
//            NSDictionary *component = [PathHelper getTopViewControllerName];
//            NSString *componentName = [component valueForKey:@"componentName"];
//            NSString *subComponent = [component valueForKey:@"subComponent"];
//            NSMutableDictionary *formatTexts = [[NSMutableDictionary alloc] init];
//            [formatTexts addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:componentName,@"name", viewControllerName,@"desc", nil]];
//            [formatTexts setValue:[component valueForKey:@"componentTitle"] forKey:@"pageTitle"];
//            if (subComponent != nil && subComponent.length > 0)
//                [formatTexts setValue:subComponent forKey:@"subName"];
//            NSNumber *nativeId = [SLConfig queryWithNSString:componentName withNSString:subComponent];
//            if (nativeId) {
//                [formatTexts setValue:[nativeId stringValue] forKey:@"nativeId"];
//            }
//            [[DisplayViewManager sharedInstance] setViewDidLoadDescWithTexts:formatTexts];
//        }
//    }
    [self hook_ViewDidAppear:animated];
}

- (void)hook_ViewWillDisappear:(BOOL)animated {
//    NSMutableDictionary *formatTexts = [[NSMutableDictionary alloc] init];
//    [[DisplayViewManager sharedInstance] setViewDidLoadDescWithTexts:formatTexts];
    [self hook_ViewWillDisappear:animated];
}

- (void)hook_ViewDidDisappear:(BOOL)animated {
    if (![self isKindOfClass:[UINavigationController class]] && ![self isKindOfClass:[UITabBarController class]]) {
//        NSString *name = [PathHelper getClassNameWithSender:self];
//        [SLMarsIO lostFocusWithNSString:name withNSString:nil];
    }
    [self hook_ViewDidDisappear:animated];
}

@end
