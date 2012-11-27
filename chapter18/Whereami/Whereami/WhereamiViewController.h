//
//  WhereamiViewController.h
//  Whereami
//
//  Created by joeconway on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereamiViewController : UIViewController
    <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D *preferredLocationCoordinate;
    CLLocation *location;
    
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *locationTitleField;
    __weak IBOutlet UISegmentedControl *mapTypeControl;
}

- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;
- (BOOL)saveLocation;

- (IBAction)changeMapType:(id)sender;

@end
