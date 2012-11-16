//
//  MapPoint.m
//  Whereami
//
//  Created by joeconway on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BNRMapPoint.h"

@implementation BNRMapPoint

@synthesize coordinate, title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
    self = [super init];
    
    if (self) {
        coordinate = c;
        [self setTitle:t];
    }
    
    return self;
}

- (id)init
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -89.32) title:@"Hometown"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        double latitude = [aDecoder decodeDoubleForKey:@"coordinate.latitude"];
        double longitude = [aDecoder decodeDoubleForKey:@"coordinate.longitude"];
        
        //CLLocationCoordinate2D test = CLLocationCoordinate2DMake(latitude, longitude);
        //[self setCoordinate:test];
        
        coordinate.latitude = latitude;
        coordinate.longitude = longitude;
        
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:coordinate.latitude forKey:@"coordinate.latitude"];
    [aCoder encodeDouble:coordinate.longitude forKey:@"coordinate.longitude"];
    [aCoder encodeObject:title forKey:@"title"];
}

@end
