//
//  MMTestObjA.m
//  XXX
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import "MMTestObjA.h"
#import "MMAutoNilHelper.h"
#import <objc/runtime.h>

@implementation MMTestObjA

- (void)dealloc {
    [super dealloc];
}

- (void)testMethod {
    __block typeof(self) bSelf = self;
    //  创建autoNilHelper，autoNilBlock中将bSelf = nil
    MMAutoNilHelper *autoNilHelper = [[MMAutoNilHelper alloc] init];
    autoNilHelper.autoNilBlock = ^{
        bSelf = nil;    //  如果没有这句，当self release时，网络请求回调中的bSelf就为野指针，造成崩溃。
    };
    //  关联自动置为nil的nilHelper对象，当self release时，释放autoNilHelper，执行autoNilBlock，设置bSelf为nil
    objc_setAssociatedObject(self, @selector(testMethod), autoNilHelper, OBJC_ASSOCIATION_RETAIN);
    [autoNilHelper release];

    //  进行网络请求
    [self qurey:^{
        if (bSelf) {
            NSLog(@"bSelf = %@ 这个指针还存在（没有被置为nil，可能是野指针）", bSelf);
        }
        else {
            NSLog(@"bSelf 不存在");
        }
    }];
}

//  假设为一个网络请求
- (void)qurey:(void(^)(void))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

@end
