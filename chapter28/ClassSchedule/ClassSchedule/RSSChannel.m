//
//  RSSChannel.m
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

@synthesize items;

#pragma mark -
#pragma mark Lifecycle methods

- (id)init
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    self = [super init];
    
    if (self) {
        // Create the container for the RSSItems this channel has
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark JSONSerializable methods

- (void)readFromJSONDictionary:(NSDictionary *)dict
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    NSArray *locationKeys = [dict allKeys];
    for (NSString *locationKey in locationKeys) {
        NSDictionary *locationDict = [dict objectForKey:locationKey];
        
        NSArray *scheduleIdKeys = [locationDict allKeys];
        for (NSString *scheduleIdKey in scheduleIdKeys) {
            NSDictionary *scheduleIdDict = [locationDict objectForKey:scheduleIdKey];
            RSSItem *item = [[RSSItem alloc] init];
            [item readFromJSONDictionary:scheduleIdDict];
            [items addObject:item];
        }
    }
}

@end
