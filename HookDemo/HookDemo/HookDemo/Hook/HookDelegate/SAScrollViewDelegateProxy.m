//
// SAScrollViewDelegateProxy.m
// SensorsAnalyticsSDK
//
// Created by 陈玉国 on 2021/1/6.
// Copyright © 2021 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAScrollViewDelegateProxy.h"
#import <objc/message.h>
//#import "UIView+Hook.h"
//#import "blackboard-Swift.h"
//#import <JRE/JRE.h>

@implementation SAScrollViewDelegateProxy

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL methodSelector = @selector(tableView:didSelectRowAtIndexPath:);
    [SAScrollViewDelegateProxy trackEventWithTarget:self scrollView:tableView atIndexPath:indexPath];
//    if ([[HookNameMapper instance] shouldStopAction]) {
//        return;
//    }
    [SAScrollViewDelegateProxy invokeWithTarget:self selector:methodSelector, tableView, indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SEL methodSelector = @selector(collectionView:didSelectItemAtIndexPath:);
    [SAScrollViewDelegateProxy trackEventWithTarget:self scrollView:collectionView atIndexPath:indexPath];
//    if ([[HookNameMapper instance] shouldStopAction]) {
//        return;
//    }
    [SAScrollViewDelegateProxy invokeWithTarget:self selector:methodSelector, collectionView, indexPath];
}

+ (void)trackEventWithTarget:(NSObject *)target scrollView:(UIScrollView *)scrollView atIndexPath:(NSIndexPath *)indexPath {
    // 当 target 和 delegate 不相等时为消息转发, 此时无需重复采集事件
    if (![target isEqual:scrollView.delegate]) {
        return;
    }

    UIView *cell = nil;
    if ([scrollView isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)scrollView;
        cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            [tableView layoutIfNeeded];
            cell = [tableView cellForRowAtIndexPath:indexPath];
        }
    } else if ([scrollView isKindOfClass:UICollectionView.class]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (!cell) {
            [collectionView layoutIfNeeded];
            cell = [collectionView cellForItemAtIndexPath:indexPath];
        }
    }

    if (!cell) {
        return;
    }
    
//    NSDictionary *component = [PathHelper getViewDesc:scrollView];
//    NSString *componentName = [component valueForKey:@"componentName"];
//    NSString *componentTitle = [component valueForKey:@"componentTitle"];
//    NSString *subComponent = [component valueForKey:@"subComponent"];
//
//    NSString *key = cell.uniqueId;
//
//    NSString *path = [cell getViewPath];
//    NSString *desc = [PathHelper getTitleWithSender:cell];
//
//    OrgJsonJSONObject *params = nil;
//    if (cell.traceParams) {
//        params = [OrgJsonJSONObject dicToJSONObject:cell.traceParams];
//    }
//
//    [SLMarsIO addClickWithNSString:componentName
//                      withNSString:subComponent
//                      withNSString:componentTitle
//                      withNSString:path
//                      withNSString:desc
//                      withNSString:key
//              withSLJsonObjectAble:params];
//
//    if (![UIView isInBlackList: subComponent]) {
//        NSMutableDictionary *formatTexts = [[NSMutableDictionary alloc] init];
//        [formatTexts addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:componentName,@"name", path,@"path", desc,@"desc", key,@"key", nil]];
//        [formatTexts setValue:componentTitle forKey:@"pageTitle"];
//        if (subComponent != nil && subComponent.length > 0)
//            [formatTexts setValue:subComponent forKey:@"subName"];
//        NSNumber *nativeId = [SLConfig queryWithNSString:componentName withNSString:subComponent];
//        if (nativeId) {
//            [formatTexts setValue:[nativeId stringValue] forKey:@"nativeId"];
//        }
//        [[DisplayViewManager sharedInstance] setClickDesc:cell texts:formatTexts];
//    }
}

@end
