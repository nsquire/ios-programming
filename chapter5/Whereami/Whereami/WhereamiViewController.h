//
//  WhereamiViewController.h
//  Whereami
//
//  Created by Nicholas Squire on 9/29/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereamiViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *locationTitleField;
}

//- (void)doSomethingWierd;

@end
