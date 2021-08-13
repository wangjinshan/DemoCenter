//
//  NSMutableArray+Safe.m
//  blackboard
//
//  Created by 山神 on 2020/5/7.
//  Copyright © 2020 xkb. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "RuntimeHelper.h"

@implementation NSMutableArray (Safe)

+ (void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self sel_swizzleSelector:@selector(removeObject:) withSwizzledSelector:@selector(jm_removeObject:)];
            
            Class cls1 = NSClassFromString(@"__NSPlaceholderArray");
            [cls1 sel_swizzleSelector:@selector(initWithObjects:count:) withSwizzledSelector:@selector(jm_initWithObjects:count:)];
            
            Class cls = NSClassFromString(@"__NSArrayM");
            
            [cls sel_swizzleSelector:@selector(addObject:) withSwizzledSelector:@selector(jm_addObject:)];
            [cls sel_swizzleSelector:@selector(removeObjectAtIndex:) withSwizzledSelector:@selector(jm_removeObjectAtIndex:)];
            [cls sel_swizzleSelector:@selector(insertObject:atIndex:) withSwizzledSelector:@selector(jm_insertObject:atIndex:)];
            [cls sel_swizzleSelector:@selector(objectAtIndex:) withSwizzledSelector:@selector(jm_objectAtIndex:)];
            [cls sel_swizzleSelector:@selector(objectAtIndexedSubscript:) withSwizzledSelector:@selector(jm_objectAtIndexedSubscript:)];
            [cls sel_swizzleSelector:@selector(replaceObjectAtIndex:withObject:) withSwizzledSelector:@selector(jm_replaceObjectAtIndex:withObject:)];
        });
    }
}

- (instancetype)jm_initWithObjects:(const id _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    BOOL hasNilObject = NO;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] == nil) {
            hasNilObject = YES;
        }
    }
    if (hasNilObject) {
        id __unsafe_unretained newObjects[cnt];
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < cnt; ++i) {
            if (objects[i] != nil) {
                newObjects[index++] = objects[i];
            }
        }
        return [self jm_initWithObjects:newObjects count:index];
    }
    return [self jm_initWithObjects:objects count:cnt];
}


- (void)jm_addObject:(id)obj {
    if (obj == nil) {
        
    } else {
        [self jm_addObject:obj];
    }
}

- (void)jm_removeObject:(id)obj {
    if (obj == nil) {
        return;
    }
    [self jm_removeObject:obj];
}

- (void)jm_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        
    } else if (index > self.count) {
        
    } else {
        [self jm_insertObject:anObject atIndex:index];
    }
}

- (id)jm_objectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        
        return nil;
    }
    if (index > self.count) {
        
        return nil;
    }
    return [self jm_objectAtIndex:index];
}

- (void)jm_removeObjectAtIndex:(NSUInteger)index {
    if (self.count <= 0) {
        
        return;
    }
    if (index >= self.count) {
        
        return;
    }
    
    [self jm_removeObjectAtIndex:index];
}

- (instancetype)jm_objectAtIndexedSubscript:(NSUInteger)index {
    if (index > (self.count - 1)) {
        
        return nil;
    } else {
        return [self jm_objectAtIndexedSubscript:index];
    }
}

- (void)jm_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index > (self.count - 1)) {
        
    } else {
        [self jm_replaceObjectAtIndex:index withObject:anObject];
    }
}

@end
