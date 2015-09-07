//
//  MMTestObjA.m
//  XXX
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import "MMTestObjA.h"
#import <objc/runtime.h>
#import "NSObject+MMAutoNilHelper.h"

@implementation MMTestObjA

- (void)dealloc {
    [super dealloc];
}

- (void)testMethod {
    __block typeof(self) bSelf = self;
    MMMrcWeakObserver(bSelf);                       //  声明:MMMrcWeak 将bSelf 变成类似 arc下的weak，实现监听，如果当bSelf释放的时候，自动设为nil
    //  进行网络请求
    [self qurey:^{
        if (bSelf) {
            NSLog(@"bSelf = %@ 这个指针还存在（没有被置为nil，可能是野指针）", bSelf);
            MMMrcWeakObserverCancel(bSelf);        //   不再监听时候，需要取消监听
        }
        else {
            NSLog(@"bSelf 不存在");
        }
    }];
}

//  假设为一个网络请求
- (void)qurey:(void(^)(void))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

@end
