//
//  Line.m
//  TouchTracker
//
//  Created by Nick on 12/8/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "Line.h"


@implementation Line

@dynamic begin;
@dynamic end;

@dynamic beginPoint;
@dynamic endPoint;

- (CGPoint)beginPoint
{
    return [[self begin] CGPointValue];
}

- (void)setBeginPoint:(CGPoint)point
{
    [self setBegin:[NSValue valueWithCGPoint:point]];
}

- (CGPoint)endPoint
{
    return [[self end] CGPointValue];
}

- (void)setEndPoint:(CGPoint)point
{
    [self setEnd:[NSValue valueWithCGPoint:point]];
}

@end
