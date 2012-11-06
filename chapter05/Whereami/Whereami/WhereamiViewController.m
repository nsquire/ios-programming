//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Nicholas Squire on 9/29/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

@interface WhereamiViewController ()

@end

@implementation WhereamiViewController{}

#pragma mark - Segment event methods

// Silver challenge
- (IBAction)segmentAction:(id)sender
{
    //NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [worldView setMapType:MKMapTypeStandard];
            break;
        case 1:
            [worldView setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [worldView setMapType:MKMapTypeHybrid];
            break;
        default:
            break;
    }
}

#pragma mark - Initialization methods


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        
        // Set the delegate, ignore warning for now
        [locationManager setDelegate:self];
        
        // And we want it to be as accurate as possible
        // regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Tell our manager to start looking for its location immediately
        //[locationManager startUpdatingLocation];
        
        // Silver challenge
        //segmentedControl = [[UISegmentedControl alloc] init];
        //[segmentedControl addTarget:self action:@selector(test:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

#pragma mark - CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
    
    // How many seconds ago was this location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationManagers will return the last found locationof the device
    // first, you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180) {
        // This is cached data, you don't want it, keep lookin
        return;
    }
    
    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

#pragma mark - MKMapView delegate methods

- (void)mapView:(MKMapView *)mapView
    didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:YES];
}

#pragma mark - UI Events

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self findLocation];
    [textField resignFirstResponder];
    
    return YES;
}

- (void)findLocation
{
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Gold challenge
    // Setup a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Get the current date
    NSDate *date = [[NSDate alloc] init];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    // Set the annotation title string
    NSString *titleWithDate = [NSString stringWithFormat:@"%@ - added on %@", [locationTitleField text], formattedDateString];
    
    // Create an instance of BNRMapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord title:titleWithDate];
    
    // Add it to the map view
    [worldView addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [worldView setRegion:region animated:YES];
    
    // Reset the UI
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:NO];
    [locationManager stopUpdatingLocation];
    
}

#pragma mark - View lifecycle methods

- (void)viewDidLoad
{
    [worldView setShowsUserLocation:YES];
    
    // Bronze challenge
    //[worldView setMapType:MKMapTypeSatellite];
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    NSLog(@"View controller destroyed");
    [locationManager setDelegate:nil];
}


@end
