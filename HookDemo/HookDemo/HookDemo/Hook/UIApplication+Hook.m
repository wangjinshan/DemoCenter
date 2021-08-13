//
//  UIApplication+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/6.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIApplication+Hook.h"
#import "RuntimeHelper.h"
//#import "blackboard-Swift.h"
//#import <XHBMars/Mars.h>
//#import <Core-Swift.h>
#import "UIView+Hook.h"
//#import <JRE/JRE.h>

/// 一个元素 $AppClick 全埋点最小时间间隔，100 毫秒
static NSTimeInterval kAppClickMinTimeInterval = 0.1;

@implementation UIApplication (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sel_exchangeFromSel:@selector(sendAction:to:from:forEvent:) toSel:@selector(hook_sendAction:to:from:forEvent:)];
    });
}

- (BOOL)hook_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event {
    if ([self isValidClickWithSender:sender] ) {
        NSDictionary *component = [PathHelper getTopViewControllerName];
        NSString *componentName = [component valueForKey:@"componentName"];
        NSString *componentTitle = [component valueForKey:@"componentTitle"];

        NSString *subComponent = nil;
        NSString *key = @"";
        NSString *title = [PathHelper getTitleWithSender:sender];
        OrgJsonJSONObject *params = nil;
        UIView *view = nil;
        
        if ([sender isKindOfClass:[UIView class]]) {
            view = (UIView *)sender;
            if (view.uniqueId) {
                key = view.uniqueId;
            }
            if (view.traceParams) {
                params = [OrgJsonJSONObject dicToJSONObject:view.traceParams];
            }
            subComponent = [[PathHelper getViewDesc:view] valueForKey:@"subComponent"];
            view.lastActionTime = [[NSProcessInfo processInfo] systemUptime];
        }
        
        if ([sender isKindOfClass:[UIBarItem class]]) {
            UIBarItem *item = (UIBarItem *)sender;
            if (item.uniqueId) {
                key = item.uniqueId;
            }
        }

        if ([sender isKindOfClass:[UISwitch class]]) {
            UISwitch *item = (UISwitch *)sender;
            if (item.uniqueId) {
                key = item.uniqueId;
            }
            if (params == nil) {
                params = [OrgJsonJSONObject dicToJSONObject:@{@"value" : item.on ? @"open": @"close"}];
            }
        }
        
        NSString *targetName = [PathHelper getClassNameWithSender:target];
        NSString *senderName = [PathHelper getDescWithSender:sender];
        NSString *actionName = NSStringFromSelector(action);
        
        BOOL isSpecailPath = [actionName isEqualToString:@"flash"];
        BOOL isText = [senderName containsString:@"UIText"];
        BOOL isHookDisplayView = [targetName isEqualToString:@"HookDisplayView"];
        BOOL isBlack = [UIView isInBlackList: subComponent];
        if (isSpecailPath || isText || isHookDisplayView || isBlack) {
            if ([self respondsToSelector:@selector(hook_sendAction:to:from:forEvent:)]) {
                return [self hook_sendAction:action to:target from:sender forEvent:event];
            }
        }
        
        NSString *path =
            [NSString stringWithFormat:@"%@/%@/%@", targetName, senderName, actionName];
        
        if (view) {
            path = [view getViewPath];
            NSMutableDictionary *formatTexts = [[NSMutableDictionary alloc] init];
            [formatTexts addEntriesFromDictionary: [NSMutableDictionary dictionaryWithObjectsAndKeys:componentName,@"name", path,@"path", title,@"desc", key,@"key", nil]];
            [formatTexts setValue:componentTitle forKey:@"pageTitle"];
            if (subComponent != nil && subComponent.length > 0)
                [formatTexts setValue:subComponent forKey:@"subName"];
            NSNumber *nativeId = [SLConfig queryWithNSString:componentName withNSString:subComponent];
            if (nativeId) {
                [formatTexts setValue:[nativeId stringValue] forKey:@"nativeId"];
            }
            [[DisplayViewManager sharedInstance] setClickDesc:view texts:formatTexts];
        }
        
        NSLog(@"UIApplication+Hook: componentName: %@ subComponent: %@ path: %@", componentName, subComponent, path);
        [SLMarsIO addClickWithNSString:componentName
                          withNSString:subComponent
                          withNSString:componentTitle
                          withNSString:path
                          withNSString:title
                          withNSString:key
                  withSLJsonObjectAble:params];
    }
    
    if ([self respondsToSelector:@selector(hook_sendAction:to:from:forEvent:)]) {
        if ([[HookNameMapper instance] shouldStopAction])
            return false;
        return [self hook_sendAction:action to:target from:sender forEvent:event];
    }
    return false;
}

- (BOOL)isValidClickWithSender:(nullable id)sender {
    BOOL isSystem = NO;
    BOOL isTimeLimit = NO;
    if (![PathHelper isSystemWithSender:sender]) {
        isSystem = YES;
    }
    if ([sender isKindOfClass:[UIView class]]) {
        NSTimeInterval lastTime = ((UIView *)sender).lastActionTime;
        NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
        if (lastTime > 0 && currentTime - lastTime < kAppClickMinTimeInterval) {
            isTimeLimit = YES;
        }
    }
    return (!isSystem && !isTimeLimit);
}

@end
