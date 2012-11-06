//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Nicholas Squire on 9/29/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "WhereamiViewController.h"

@interface WhereamiViewController ()

@end

@implementation WhereamiViewController
{}
/*
 - (void)doSomethingWierd
 {
 NSLog(@"Line 1");
 NSLog(@"Line 2");
 NSLog(@"Line 3");
 }
 */

#pragma mark - Initialization methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        
        //[self doSomethingWierd];
        
        // Set the delegate, ignore warning for now
        [locationManager setDelegate:self];
        
        // And we want it to be as accurate as possible
        // regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Bronze challenge
        [locationManager setDistanceFilter:50];
        
        // Tell our manager to start looking for its location immediately
        [locationManager startUpdatingLocation];
        
        // Silver challenge
        
        if ([CLLocationManager headingAvailable]) {
            // Set accuracy for heading updates
            [locationManager setHeadingFilter:5];
            
            // Tell our manager to start looking for heading information immediately
            [locationManager startUpdatingHeading];
        } else {
            NSLog(@"Heading info not available");
        }
        
    }
    
    return self;
}

#pragma mark - CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    if ([newHeading headingAccuracy] < 0) {
        return;
    }
    
    // Use the true heading if it is valid
    CLLocationDirection theHeading = (([newHeading trueHeading] > 0) ? [newHeading trueHeading] : [newHeading magneticHeading]);
    
    NSLog(@"heading: %f", theHeading);
}

#pragma mark - Lifecycle methods

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    NSLog(@"View controller destroyed");
    [locationManager setDelegate:nil];
}


@end
