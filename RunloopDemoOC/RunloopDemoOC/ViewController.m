//
//  ViewController.m
//  RunloopDemoOC
//
//  Created by 山神 on 2020/6/19.
//  Copyright © 2020 山神. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self performSelectorOnMainThread:@selector(action_performSelector) withObject:nil waitUntilDone:true];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

void test1() {
    printf("------test1-----");
}

void test2() {
    printf("-------test2------");
}


- (void)action_performSelector {
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(
                                                                       CFAllocatorGetDefault(),
                                                                       kCFRunLoopAllActivities,
                                                                       YES,
                                                                       0,
                                                                       ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"Runloop 状态改变了：%zd", activity);
    });

    // 将 observer 添加到当前 Runloop 中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);

    // CF 对象，需手动管理内存
    CFRelease(observer);

}



@end
