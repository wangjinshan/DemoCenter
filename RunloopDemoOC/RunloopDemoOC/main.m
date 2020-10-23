//
//  main.m
//  RunloopDemoOC
//
//  Created by 山神 on 2020/6/19.
//  Copyright © 2020 山神. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int test() {
   /* 局部变量定义 */
   int a = 10;
   /* do 循环执行 */
   LOOP:do
   {
      if( a == 15)
      {
         /* 跳过迭代 */
         a = a + 1;
         goto LOOP;
      }
      printf("a 的值： %d\n", a);
      a++;

   }while( a < 20 );

   return 0;
}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
       int c = test();
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

