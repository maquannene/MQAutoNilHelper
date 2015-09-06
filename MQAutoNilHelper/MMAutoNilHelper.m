//
//  MMAutoNilHelper.m
//  XXX
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import "MMAutoNilHelper.h"

@implementation MMAutoNilHelper

- (void)dealloc {
    if (_autoNilBlock) {
        _autoNilBlock();
    }
    self.autoNilBlock = nil;
    [super dealloc];
}

@end
