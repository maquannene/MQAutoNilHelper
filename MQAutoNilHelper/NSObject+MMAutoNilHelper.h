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
[x MMMrcWeak:^MMAutoNilBlock(MMAutoNilHelper *autoNilHelper) {                      \
    objc_setAssociatedObject(x, x, autoNilHelper, OBJC_ASSOCIATION_RETAIN);         \
    return [[^{                                                                     \
        x = nil;                                                                    \
    } copy] autorelease];                                                           \
}];                                                                                 \

#endif
#endif

#ifndef MMMrcWeakObserverCancel
#if __has_feature(objc_arc)
#define MMMrcWeakObserverCancel(x) (x)
#else
#define MMMrcWeakObserverCancel(x)                                                  \
objc_setAssociatedObject(x, x, nil, OBJC_ASSOCIATION_RETAIN);                       \

#endif
#endif

@class MMAutoNilHelper;

typedef void(^MMAutoNilBlock)(void);
typedef MMAutoNilBlock(^MMAutoNilConfigureBlock)(MMAutoNilHelper *);

@interface MMAutoNilHelper : NSObject

@property (nonatomic, copy) MMAutoNilBlock autoNilBlock;

@end

@interface NSObject (MMAutoNilHelper)

- (void)MMMrcWeak:(MMAutoNilConfigureBlock)autoNilConfigureBlock;

@end
