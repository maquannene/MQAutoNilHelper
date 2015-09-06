//
//  NSObject+MMAutoNilHelper.h
//  MQAutoNilHelper
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef MMMrcWeak
#if __has_feature(objc_arc)
#define MMMrcWeak(x) (x)
#else
#define MMMrcWeak(x)    \
[x MMMrcWeak:^{         \
x = nil;                \
}];                     \

#endif
#endif

@interface MMAutoNilHelper : NSObject

@property (nonatomic, copy) void(^autoNilBlock)(void);

@end

@interface NSObject (MMAutoNilHelper)

- (void)MMMrcWeak:(void(^)(void))autoNilBlock;

@end
