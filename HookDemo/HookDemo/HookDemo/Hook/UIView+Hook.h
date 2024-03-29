//
//  UIView+Hook.h
//  blackboard
//
//  Created by roni on 2018/12/18.
//  Copyright © 2018 xkb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Hook)

- (UIImage *)viewSnapshot;

+ (BOOL)isInBlackList: (NSString *)controlName;

- (UIViewController *)getViewController;

- (NSString *)getViewControllerPath;

- (NSString *)getViewPath;

@property(nonatomic, assign) NSTimeInterval lastActionTime;

@end

NS_ASSUME_NONNULL_END
