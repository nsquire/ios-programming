//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Nicholas Squire on 9/25/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

- (id) init
{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:@""];
}

- (id) initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super init];
    
    if (self) {
        [self setItemName:name];
        [self setValueInDollars:value];
        [self setSerialNumber:sNumber];
        dateCreated = [[NSDate alloc] init];
    }
    return self;
}

- (void) setItemName:(NSString *)str
{
    itemName = str;
}

- (NSString *) itemName
{
    return itemName;
}

- (void) setSerialNumber:(NSString *)str
{
    serialNumber = str;
}

- (NSString *)serialNumber
{
    return serialNumber;
}

- (void) setValueInDollars:(int)i
{
    valueInDollars = i;
}

- (int) valueInDollars
{
    return valueInDollars;
}

- (NSDate *) dateCreated
{
    return dateCreated;
}

- (NSString *) description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", itemName, serialNumber, valueInDollars, dateCreated];
    
    return descriptionString;
}

@end
