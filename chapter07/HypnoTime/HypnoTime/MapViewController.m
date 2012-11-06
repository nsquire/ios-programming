//
//  MapViewController.m
//  HypnoTime
//
//  Created by Nick on 10/14/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

// Bronze challenge

#import "MapViewController.h"

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        UITabBarItem *i = [self tabBarItem];
        [i setTitle:@"Map"];
    }
    
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    MKMapView *map = [[MKMapView alloc] initWithFrame:frame];
    [self setView:map];
}

@end
