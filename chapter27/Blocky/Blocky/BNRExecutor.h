//
//  BNRExecutor.h
//  Blocky
//
//  Created by Nick on 1/14/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRExecutor : NSObject

@property (nonatomic, copy) int (^equation)(int, int);

- (int)computeWithValue:(int)value1 andValue:(int)value2;

@end
