//
//  NSObject+MMAutoNilHelper.h
//  MQAutoNilHelper
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef MMMrcWeakObserver
#if __has_feature(objc_arc)
#define MMMrcWeakObserver(x) (x)
#else
#define MMMrcWeakObserver(x)                                                        \
void * ptr = &x;                                                                    \
[x MMMrcWeak:^(MMAutoNilHelper *autoNilHelper) {                                    \
    objc_setAssociatedObject(x, ptr, autoNilHelper, OBJC_ASSOCIATION_RETAIN);       \
    autoNilHelper.autoNilBlock = ^{                                                 \
        bSelf = nil;                                                                \
    };                                                                              \
}];                                                                                 \

#endif
#endif

#ifndef MMMrcWeakObserverCancel
#if __has_feature(objc_arc)
#define MMMrcWeakObserverCancel(x) (x)
#else
#define MMMrcWeakObserverCancel(x)                                                  \
objc_setAssociatedObject(x, ptr, nil, OBJC_ASSOCIATION_RETAIN);                     \

#endif
#endif

@class MMAutoNilHelper;

typedef void(^MMAutoNilBlock)(void);
typedef void(^MMAutoNilConfigureBlock)(MMAutoNilHelper *);

@interface MMAutoNilHelper : NSObject

@property (nonatomic, copy) MMAutoNilBlock autoNilBlock;
@property (nonatomic, assign) void *ptr;

@end

@interface NSObject (MMAutoNilHelper)

- (void)MMMrcWeak:(MMAutoNilConfigureBlock)autoNilConfigureBlock;

@end
