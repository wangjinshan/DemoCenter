//
//  NSArray+Safe.m
//  blackboard
//
//  Created by 山神 on 2020/5/7.
//  Copyright © 2020 xkb. All rights reserved.
//

#import "NSArray+Safe.h"
#import "RuntimeHelper.h"

@implementation NSArray (Safe)

+ (void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class cls = NSClassFromString(@"__NSArrayI");
            [cls sel_swizzleSelector:@selector(objectAtIndex:) withSwizzledSelector:@selector(jm_objectAtIndex:)];
            [cls sel_swizzleSelector:@selector(objectAtIndexedSubscript:) withSwizzledSelector:@selector(jm_objectAtIndexedSubscript:)];
        });
    }
}

- (instancetype)jm_objectAtIndex:(NSUInteger)index {
    if (index > (self.count - 1)) {
        return nil;
    } else {
        return [self jm_objectAtIndex:index];
    }
}

- (instancetype)jm_objectAtIndexedSubscript:(NSUInteger)index {
    if (index > (self.count - 1)) {
        return nil;
    } else {
        return [self jm_objectAtIndexedSubscript:index];
    }
}

@end
