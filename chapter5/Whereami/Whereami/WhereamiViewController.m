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
        
        // Tell our manager to start looking for its location immediately
        //[locationManager startUpdatingLocation];
    }
    
    return self;
}

/*
- (void)doSomethingWierd
{
    NSLog(@"Line 1");
    NSLog(@"Line 2");
    NSLog(@"Line 3");
}
*/

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

#pragma mark - MKMapView delegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:YES];
}

#pragma mark - View lifecycle methods

- (void)viewDidLoad
{
    [worldView setShowsUserLocation:YES];
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    NSLog(@"View controller destroyed");
    [locationManager setDelegate:nil];
}


@end
