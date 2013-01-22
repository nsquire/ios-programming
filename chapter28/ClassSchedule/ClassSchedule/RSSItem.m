//
//  BNRClass.m
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

@synthesize title;
@synthesize location;
@synthesize startDate;
@synthesize endDate;
@synthesize instructor;
@synthesize offeringId;

#pragma mark -
#pragma mark JSONSerializable methods

-(void)readFromJSONDictionary:(NSDictionary *)dict
{
    NSLog(@"Dict: %@", dict);
    
    [self setTitle:[NSString stringWithFormat:@"Title: %@", [dict valueForKey:@"title"]]];
    [self setLocation:[NSString stringWithFormat:@"Location: %@", [dict valueForKey:@"locality"]]];
    [self setStartDate:[NSString stringWithFormat:@"Class Begins: %@", [dict valueForKey:@"class_begins"]]];
    [self setEndDate:[NSString stringWithFormat:@"Class Ends: %@", [dict valueForKey:@"class_ends"]]];
    [self setInstructor:[NSString stringWithFormat:@"Insructor: %@", [dict valueForKey:@"instructor_one"]]];
    [self setOfferingId:[NSString stringWithFormat:@"ID: %@", [dict valueForKey:@"offering_id"]]];
}

@end
