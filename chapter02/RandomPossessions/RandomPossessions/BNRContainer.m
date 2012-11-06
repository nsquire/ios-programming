//
//  BNRContainter.m
//  RandomPossessions
//
//  Created by Nicholas Squire on 9/27/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

// Gold challenge

#import "BNRContainer.h"

@implementation BNRContainer

- (id)init
{
    return [self initWithItemName:@"Containter name" valueInDollars:0 serialNumber:@""];
}

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super initWithItemName:name valueInDollars:value serialNumber:sNumber];
    
    if (self) {
        subItems = [NSMutableArray array];
    }
    
    return self;
}

- (NSMutableArray *)subItems
{
    return subItems;
}

- (void)setSubItems:(NSMutableArray *)value
{
    subItems = value;
}

- (NSString *)description
{
    // Printing the description of a BNRContainer should show you the name of the container,
    // its value in dollars (a sum of all items in the container plus the value of the
    // container itself), and a list of every BNRItem it contains.
    
 
    int totalValue = [self valueInDollars];
    
    for (BNRItem *item in subItems) {
        totalValue += [item valueInDollars];
    }
    
    NSMutableString *desc = [NSMutableString stringWithFormat:@"Name: %@, Total value: $%i with items:\n", [self itemName], totalValue];
    
    for (BNRItem *item in subItems) {
        [desc appendFormat:@"%@\n", item];
    }
    
    return desc;
}

@end
