
//
//  NSObject+MQAutoNilHelper.m
//  MQAutoNilHelper
//
//  Created by 马权 on 9/6/15.
//  Copyright (c) 2015 马权. All rights reserved.
//

#import "NSObject+MQAutoNilHelper.h"
#import "MMAutoNilHelper.h"

@implementation NSObject (MQAutoNilHelper)

- (void)setAutoNil:(NSObject *)object {
//    //  创建autoNilHelper，autoNilBlock中将bSelf = nil
//    MMAutoNilHelper *autoNilHelper = [[MMAutoNilHelper alloc] init];
//    autoNilHelper.autoNilBlock = ^{
//        object = nil;    //  如果没有这句，当self release时，网络请求回调中的bSelf就为野指针，造成崩溃。
//    };
//    //  关联自动置为nil的nilHelper对象，当self release时，释放autoNilHelper，执行autoNilBlock，设置bSelf为nil
//    objc_setAssociatedObject(self, @selector(testMethod), autoNilHelper, OBJC_ASSOCIATION_RETAIN);
//    [autoNilHelper release];
}

@end
