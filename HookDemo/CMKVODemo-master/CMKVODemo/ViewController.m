//
//  ViewController.m
//  CMKVODemo
//
//  Created by ChenMan on 2018/4/19.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import "ViewController.h"
#import "ObservedObject.h"

#import "NSObject+Delegate_KVO.h"
#import "NSObject+Block_KVO.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ObservedObject * object = [ObservedObject new];
    object.observedNum = @111;
    
#pragma mark - Observed By Delegate
    //    [object CM_addObserver: self forKey: @"observedNum"];
    
#pragma mark - Observed By Block
    [object CM_addObserver: self forKey: @"observedNum" withBlock: ^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
        NSLog(@"Value had changed yet with observing Block");
        NSLog(@"oldValue---%@",oldValue);
        NSLog(@"newValue---%@",newValue);
    }];
    
    object.observedNum = @888;
}

#pragma mark - ObserverDelegate
-(void)CM_ObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object oldValue:(id)oldValue newValue:(id)newValue{
    NSLog(@"Value had changed yet with observing Delegate");
    NSLog(@"oldValue---%@",oldValue);
    NSLog(@"newValue---%@",newValue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// const 类型 * 变量名：可以改变指针的指向，不能改变指针指向的内容。
//- (void)demoConst1 {
//    int x = 1;
//    int y = 2;
//    const int *px = &x; // 让指针px指向变量x
//    px = &y; // 改变指针px的指向，使其指向变量y
//    *px = 3;
//}

// 类型 * const 变量名：可以改变指针指向的内容，不能改变指针的指向
//- (void)demoConst2 {
//    int x = 1;
//    int y = 2;
//    int * const px = &x; // 让指针px指向变量x
//    px = &y;    // 改变px的指向，出错：Read-only variable is not assignable
//    (*px) += 2; // 改变px指向的变量x的值
//}

// const 类型 * const 变量名：指针的指向、指针指向的内容都不可以改变。
//- (void)demoConst3 {
//    int x = 1;
//    int y = 2;
//    const int * const px = &x; // 让指针px指向变量x
//    px = &y;    // 改变px的指向，出错：Read-only variable is not assignable
//    (*px) += 2;
//}

- (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];

    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];

    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];

    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

@end
