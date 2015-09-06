//
//  NSObject+MQAutoNilHelper.h
//  MQAutoNilHelper
//
//  Created by 马权 on 9/6/15.
//  Copyright (c) 2015 马权. All rights reserved.
//

//#define MQWeak(objc) [objc setAutoNil];

#import <Foundation/Foundation.h>

@interface NSObject (MQAutoNilHelper)

- (void)setAutoNil:(NSObject *)object;

@end
