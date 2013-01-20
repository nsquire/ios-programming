//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by Nick on 1/20/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation BNRConnection

@synthesize request, completionBlock, xmlRootObject, jsonRootObject;

-(id)initWithRequest:(NSURLRequest *)req
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    self = [super init];
    
    if (self) {
        [self setRequest:req];
    }
    
    return self;
}

-(void)start
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Initialize container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    
    // Spawn connection
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:YES];
    
    // If this is the first connection started, create the array
    if (!sharedConnectionList) {
        sharedConnectionList = [[NSMutableArray alloc] init];
        
        // Add the connection to the array so it doesn't get destroyed
        [sharedConnectionList addObject:self];
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    id rootObject = nil;
    
    // If there is a "root object"
    if ([self xmlRootObject]) {
        // Create a parser with the incoming data and let the root
        // object parse its contents
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:container];
        [parser setDelegate:[self xmlRootObject]];
        [parser parse];
        rootObject = [self xmlRootObject];
    } else if ([self jsonRootObject]) {
        // Turn JSON data into basic model objects
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:container
                                                          options:0
                                                            error:nil];
        
        // Have the root object construct itself from basic model objects
        [[self jsonRootObject] readFromJSONDictionary:d];
        
        rootObject = [self jsonRootObject];
    }
    
    // Then pass the root object to the completion block - remember,
    // this is the block that the controller supplied
    if ([self completionBlock]) {
        [self completionBlock](rootObject, nil);
    }
    
    // Now, destroy this connection
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Pass the error from the connection to the completion block
    if ([self completionBlock]) {
        [self completionBlock](nil, error);
    }
    
    // Destory this connection
    [sharedConnectionList removeObject:self];
}

@end
