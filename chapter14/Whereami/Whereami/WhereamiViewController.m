//
//  WhereamiViewController.m
//  Whereami
//
//  Created by joeconway on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

@implementation WhereamiViewController
{
    BNRMapPoint *mp;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ran");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        NSString *path = [self itemArchivePath];
        mp = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"- (void)viewDidLoad ran");
    
    [worldView setShowsUserLocation:YES];
    
    if (mp) {
        NSLog(@"MP loaded, adding annotation");
        [worldView addAnnotation:mp];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
    NSLog(@"- (BOOL)textFieldShouldReturn:(UITextField *)tf ran");
    
    // This method isn't implemented yet - but will be soon.
    [self findLocation];
    
    [tf resignFirstResponder];
    
    return YES;
}

- (void)findLocation
{
    NSLog(@"- (void)findLocation ran");
    
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    NSLog(@"- (void)foundLocation:(CLLocation *)loc ran");
    
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Create an instance of MapPoint with the current data
    mp = [[BNRMapPoint alloc] initWithCoordinate:coord
                                           title:[locationTitleField text]];
    
    // Add it to the map view
    [worldView addAnnotation:mp];
        
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [worldView setRegion:region animated:YES];
    
    [locationTitleField setText:@""];
    [activityIndicator stopAnimating];
    [locationTitleField setHidden:NO];
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation ran");
    
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationManagers will return the last found location of the 
    // device first, you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
    
    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)u
{
    NSLog(@"- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)u ran");
    
    CLLocationCoordinate2D loc = [u coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:YES];
}

- (NSString *)itemArchivePath
{
    NSLog(@"- (NSString *)itemArchivePath ran");
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSLog(@"- (BOOL)saveChanges ran");
    
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:mp toFile:path];
}

- (void)dealloc
{
    NSLog(@"- (void)dealloc ran");
    
    // Tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}

@end
