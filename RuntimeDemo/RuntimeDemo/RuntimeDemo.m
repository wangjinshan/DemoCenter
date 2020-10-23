//
//  RuntimeDemo.m
//  RuntimeDemo
//
//  Created by 山神 on 2020/6/4.
//  Copyright © 2020 山神. All rights reserved.
//

#import "RuntimeDemo.h"


struct DDK;

typedef struct IJS demo;

union address_isa {
    struct {
        long age : 1;
    };
} jdk;

void testName() {
    NSLog(@"------%d",jdk.age);
}

@implementation RuntimeDemo

- (void)demo {

    NSLog(@"%@", [self class]);
    NSLog(@"%@", [super class]);
    testName();
}


@end
