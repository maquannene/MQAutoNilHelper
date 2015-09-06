//
//  MMAutoNilHelper.h
//  XXX
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMAutoNilHelper : NSObject

@property (nonatomic, copy) void(^autoNilBlock)(void);

@end
