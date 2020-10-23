//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 山神 on 2020/6/4.
//  Copyright © 2020 山神. All rights reserved.
//

#import "ViewController.h"
#import "RuntimeDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RuntimeDemo *test = [RuntimeDemo new];
    [test demo];
}


@end
