//
//  main.m
//  MQAutoNilHelper
//
//  Created by 马权 on 9/6/15.
//  Copyright © 2015 马权. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMTestObjA.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        MMTestObjA *objcA = [[MMTestObjA alloc] init];
        [objcA testMethod];
        [objcA release];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
