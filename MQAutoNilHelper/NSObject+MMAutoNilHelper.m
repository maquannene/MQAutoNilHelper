//
//  NSObject+MMAutoNilHelper.m
//  MQAutoNilHelper
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import "NSObject+MMAutoNilHelper.h"
#import <objc/runtime.h>

@implementation MMAutoNilHelper

- (void)dealloc {
    if (_autoNilBlock) {
        _autoNilBlock();
    }
    self.autoNilBlock = nil;
    [super dealloc];
}

@end

@implementation NSObject (MMAutoNilHelper)

- (void)MMMrcWeak:(void (^)(void))autoNilBlock {
    MMAutoNilHelper *autoNilHelper = [[MMAutoNilHelper alloc] init];
    autoNilHelper.autoNilBlock = autoNilBlock;
    objc_setAssociatedObject(self, &autoNilHelper, autoNilHelper, OBJC_ASSOCIATION_RETAIN);
    [autoNilHelper release];
}

@end
