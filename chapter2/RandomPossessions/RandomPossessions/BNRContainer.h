//
//  BNRContainter.h
//  RandomPossessions
//
//  Created by Nicholas Squire on 9/27/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"

@interface BNRContainer : BNRItem
{
    NSMutableArray *subItems;
}

-(NSString *)description;

@end
