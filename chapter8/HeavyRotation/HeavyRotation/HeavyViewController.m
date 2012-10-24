//
//  HeavyViewController.m
//  HeavyRotation
//
//  Created by Nick on 10/20/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "HeavyViewController.h"

@interface HeavyViewController ()

@end

@implementation HeavyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Bronze challenge
    UIDevice *device =[UIDevice currentDevice];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [device setProximityMonitoringEnabled:YES];
    
    [nc addObserver:self
           selector:@selector(nearFace:)
               name:UIDeviceProximityStateDidChangeNotification
             object:device];
    
    // For simulator
    [nc postNotificationName:UIDeviceProximityStateDidChangeNotification object:device];
    
    // Silver challenge
    [mySlider setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin |
                                  UIViewAutoresizingFlexibleWidth];
    
    [myImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin];
    
    [button1 setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin];
    
    [button2 setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleTopMargin];
    
    
}

- (void)nearFace:(NSNotification *)note
{
    NSLog(@"proximity method called");
    NSLog(@"state: %c", [[UIDevice currentDevice] proximityState]);
    
    // Condition doesn't work with simulator
    //if ([[UIDevice currentDevice] proximityState] == YES) {
        [[self view] setBackgroundColor:[UIColor darkGrayColor]];
    //}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    CGRect bounds = [[self view] bounds];
    
    // If the orientation is moving to landscape mode, move the button
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [goldButton setCenter:CGPointMake(bounds.size.width - 57.0, bounds.size.height - 140.0)];
    } else {
        [goldButton setCenter:CGPointMake(bounds.size.width - 264.0, bounds.size.height - 140.0)];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
    //return UIInterfaceOrientationMaskPortrait;
}

@end
