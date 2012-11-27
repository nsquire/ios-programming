//
//  WhereamiViewController.m
//  Whereami
//
//  Created by joeconway on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

NSString * const WhereamiMapTypePrefKey = @"WhereamiMapTypePrefKey";
//NSString * const WhereamiLatitudePrefKey = @"WhereamiLatitudePrefKey";
//NSString * const WhereamiLongitudePrefKey = @"WhereamiLongitudePrefKey";

@implementation WhereamiViewController

+ (void)initialize
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:1]
                                                         forKey:WhereamiMapTypePrefKey];
    
    // Add a default map zoom location
    //[defaults setValue:[NSNumber numberWithDouble:36.11413] forKey:WhereamiLatitudePrefKey];
    //[defaults setValue:[NSNumber numberWithDouble:-115.170024] forKey:WhereamiLongitudePrefKey];
    
    NSLog(@"Defaults: %@", defaults);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        locationManager = [[CLLocationManager alloc] init];        
        [locationManager setDelegate:self];        
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [worldView setShowsUserLocation:YES];
    
    NSInteger mapTypeValue = [[NSUserDefaults standardUserDefaults]
                              integerForKey:WhereamiMapTypePrefKey];
    
    // Update the UI
    [mapTypeControl setSelectedSegmentIndex:mapTypeValue];
    
    // Update the map
    [self changeMapType:mapTypeControl];
    
    
    
    // Get the saved latitude and longitude if they are there
    /*
     double latitude = [[NSUserDefaults standardUserDefaults]
     doubleForKey:WhereamiLatitudePrefKey];
     
     double longitude = [[NSUserDefaults standardUserDefaults]
     doubleForKey:WhereamiLongitudePrefKey];
     */
    
    location = [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemArchivePath]];
    
    if (location) {
        NSLog(@"Have location: %@", location);
        
        // Setup the location for the map to zoom to
        CLLocationCoordinate2D coord;
        coord.latitude = [location coordinate].latitude;
        coord.longitude = [location coordinate].longitude;
        
        NSLog(@"coord: %f %f", coord.latitude, coord.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
        
        // Update the map
        [worldView setRegion:region animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [self findLocation];
    [tf resignFirstResponder];
    
    return YES;
}

- (void)findLocation
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [locationManager startUpdatingLocation];
    [activityIndicator startAnimating];
    [locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)loc
{
    NSLog(@"In: %@, loc: %@", NSStringFromSelector(_cmd), loc);
    
    CLLocationCoordinate2D coord = [loc coordinate];
    
    // Note the latitude and longitude in user defaults
    //[[NSUserDefaults standardUserDefaults] setDouble:coord.latitude forKey:WhereamiLatitudePrefKey];
    //[[NSUserDefaults standardUserDefaults] setDouble:coord.longitude forKey:WhereamiLongitudePrefKey];
    
    location = loc;
    [self saveLocation];
    
    // Create an instance of MapPoint with the current data
    BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord
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

- (IBAction)changeMapType:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [[NSUserDefaults standardUserDefaults]
            setInteger:[sender selectedSegmentIndex]
                forKey:WhereamiMapTypePrefKey];
    
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

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"In: %@, Old location: %@, New location: %@", NSStringFromSelector(_cmd), oldLocation, newLocation);
    
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

- (void)mapView:(MKMapView *)mv
    didUpdateUserLocation:(MKUserLocation *)u
{
    NSLog(@"In: %@, User location: %@", NSStringFromSelector(_cmd), u);
    
    CLLocationCoordinate2D loc = [u coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [worldView setRegion:region animated:YES];
}

- (BOOL)saveLocation
{
    return [NSKeyedArchiver archiveRootObject:location toFile:[self itemArchivePath]];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"location.archive"];
}

- (void)dealloc
{
    // Tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}
@end
