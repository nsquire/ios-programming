//
//  main.m
//  RandomPossessions
//
//  Created by Nicholas Squire on 9/24/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRContainer.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Create a mutable array object, store its address in items variable
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        // Send the message addObject: to the NSMutableArray pointed to
        // by the variable items, passing a string each time.
        /*
        [items addObject:@"One"];
        [items addObject:@"Two"];
        [items addObject:@"Three"];
        
        // Send another message, insertObject:atIndex, to that same array object
        [items insertObject:@"Zero" atIndex:0];
        
        // For every item in the array as determined by sending count to items
        for (int i = 0; i < [items count]; i++) {
            // We get the ith object from the array and pass it as an argument to
            // NSLog, which implicitly sends the description message to that object
            NSLog(@"%@", [items objectAtIndex:i]);
        }
        */
        
         /*
        BNRItem *p = [[BNRItem alloc] initWithItemName:@"Red Sofa" valueInDollars:100 serialNumber:@"A1B2C"];
       
        NSLog(@"%@", p);
        
        [p setItemName:@"Red Sofa"];
        [p setSerialNumber:@"A1B2C"];
        [p setValueInDollars:100];
        
        //NSLog(@"%@ %@ %@ %d", [p itemName], [p dateCreated], [p serialNumber], [p valueInDollars]);
        NSLog(@"%@", p);
        */
        
        for (int i = 0; i < 10; i++) {
            BNRItem *p = [BNRItem randomItem];
            //[p doSomethingWierd];
            [items addObject:p];
        }
        
        /*
        for (int i = 0; i < [items count]; i++) {
            NSLog(@"%@", [items objectAtIndex:i]);
        }
        */
        
        for (BNRItem *item in items) {
            NSLog(@"%@", item);
        }
        
        // Bronze challenge
        //BNRItem *error = [items objectAtIndex:10];
        
        // Silver challenge
        BNRItem *p2 = [[BNRItem alloc] initWithItemName:@"Red Sofa2" serialNumber:@"A1B2C2"];
        NSLog(@"p2: %@", p2);

        
        // Destroy the array pointed to by items
        items = nil;
        
        // Gold challenge
        
        // Initialize objects
        BNRContainer *container1 = [[BNRContainer alloc] initWithItemName:@"container 1"
                                                           valueInDollars:1
                                                             serialNumber:@"abc123"];
        
        BNRContainer *container2 = [[BNRContainer alloc] initWithItemName:@"container 2"
                                                           valueInDollars:10
                                                             serialNumber:@"abc789"];
        
        BNRItem *item1 = [[BNRItem alloc] initWithItemName:@"item 1"
                                            valueInDollars:11
                                              serialNumber:@"xyz123"];
        
        BNRItem *item2 = [[BNRItem alloc] initWithItemName:@"item 2"
                                            valueInDollars:12
                                              serialNumber:@"xyz789"];
        
        BNRItem *item3 = [[BNRItem alloc] initWithItemName:@"item 3"
                                            valueInDollars:13
                                              serialNumber:@"xyz999"];
        
        // Link Items to containers
        [[container1 subItems] addObject:item1];
        [[container1 subItems] addObject:item2];
        [[container1 subItems] addObject:container2];
        [[container2 subItems] addObject:item3];
        
        // Print out results
        NSLog(@"%@", container1);

        
    }
    return 0;
}

