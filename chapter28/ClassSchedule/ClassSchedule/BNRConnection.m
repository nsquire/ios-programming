//
//  BNRConnection.m
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation BNRConnection

@synthesize request, completionBlock, jsonRootObject;

#pragma mark -
#pragma mark Lifecycle methods

-(id)initWithRequest:(NSURLRequest *)req
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    self = [super init];
    
    if (self) {
        [self setRequest:req];
    }
    
    return self;
}

#pragma mark -
#pragma mark Instance methods

-(void)start
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    container = [[NSMutableData alloc] init];
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:YES];
    
    if (!sharedConnectionList) {
        sharedConnectionList = [[NSMutableArray alloc] init];
    }
    
    [sharedConnectionList addObject:self];
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    id rootObject = nil;
    
    if ([self jsonRootObject]) {
        // Turn JSON data into basic model objects
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:container
                                                             options:0
                                                               error:nil];
        [[self jsonRootObject] readFromJSONDictionary:dict];
        rootObject = [self jsonRootObject];
    }
    
    // Then pass the root object to the completion block
    if ([self completionBlock]) {
        [self completionBlock](rootObject, nil);
    }
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Pass the error from the connection to the completion block
    if ([self completionBlock]) {
        [self completionBlock](nil, error);
    }
    
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}

@end
