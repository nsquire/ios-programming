//
//  BNRClassStore.m
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import "BNRClassStore.h"
#import "BNRConnection.h"
#import "RSSChannel.h"

@implementation BNRClassStore

#pragma mark -
#pragma mark Class methods

+(BNRClassStore *)sharedStore
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    static BNRClassStore *classStore = nil;
    
    if (!classStore) {
        classStore = [[BNRClassStore alloc] init];
    }
    
    return classStore;
    
}

#pragma mark -
#pragma mark Instance methods

-(void)fetchClassesWithCompletion:(void (^)(RSSChannel *obj, NSError *err))block
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    NSURL *url = [NSURL URLWithString:@"http://www.bignerdranch.com/json/schedule"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RSSChannel *channel = [[RSSChannel alloc] init];
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:request];
    [connection setCompletionBlock:block];
    [connection setJsonRootObject:channel];
    [connection start];
}

@end
