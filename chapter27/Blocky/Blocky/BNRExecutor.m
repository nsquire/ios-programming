//
//  BNRExecutor.m
//  Blocky
//
//  Created by Nick on 1/14/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import "BNRExecutor.h"

@implementation BNRExecutor

@synthesize equation;

- (int)computeWithValue:(int)value1 andValue:(int)value2
{
    // If a block variable is executed but doesn't point to a block,
    // it will crash - return 0 if there is no block
    if (!equation) {
        return 0;
    }
    
    // Return value of block with value1 and value2
    return equation(value1, value2);
}

- (void)dealloc
{
    NSLog(@"Executor is being destroyed");
}

@end
