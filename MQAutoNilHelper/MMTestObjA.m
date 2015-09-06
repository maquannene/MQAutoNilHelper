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
#import "NSObject+MQAutoNilHelper.h"

#define MQMrcWeak(x)                                                                            \
MMAutoNilHelper *autoNilHelper = [[MMAutoNilHelper alloc] init];                                \
autoNilHelper.autoNilBlock = ^{                                                                 \
    x = nil;                                                                                    \
};                                                                                              \
objc_setAssociatedObject(self, "MQMrcWeak", autoNilHelper, OBJC_ASSOCIATION_RETAIN);            \
[autoNilHelper release];                                                                        \

@implementation MMTestObjA

- (void)dealloc {
    [super dealloc];
}

- (void)testMethod {
    __block typeof(self) bSelf = self;
    MQMrcWeak(bSelf);   //  类似arc 下weak，如果回调时self被释放，那么bSelf自动置为nil
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
