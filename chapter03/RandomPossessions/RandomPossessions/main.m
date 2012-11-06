//
//  main.m
//  RandomPossessions
//
//  Created by Nicholas Squire on 9/24/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Create a mutable array object, store its address in items variable
        //NSMutableArray *items = [[NSMutableArray alloc] init];
        
        BNRItem *backpack = [[BNRItem alloc] init];
        [backpack setItemName:@"Backpack"];
        //[items addObject:backpack];
        
        BNRItem *calculator = [[BNRItem alloc] init];
        [calculator setItemName:@"calculator"];
        //[items addObject:calculator];
        
        [backpack setContainedItem:calculator];
        
        // Destroy the array pointed to by items
        //NSLog(@"Setting items to nil...");
        //items = nil;
        
        backpack = nil;
        
        NSLog(@"Container %@", [calculator container]);
        
        calculator = nil;
    }
    return 0;
}

