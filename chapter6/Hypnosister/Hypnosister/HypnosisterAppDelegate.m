//
//  HypnosisterAppDelegate.m
//  Hypnosister
//
//  Created by Nick on 10/6/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "HypnosisterAppDelegate.h"
#import "HypnosisView.h"
#import "LogoView.h"

@implementation HypnosisterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // Override point for customization after application launch.
    
    CGRect screenRect = [[self window] bounds];
    
    // Create a UIScrollView to have the size of the window, matching its size
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:5.0];
    
    // Will get a warning, ignore for now
    [scrollView setDelegate:self];
    
    [[self window] addSubview:scrollView];

    // Create a HypnosisView with a frame that is twice as wide as the screen
    CGRect bigRect = screenRect;

    view = [[HypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:view];
    
    // Tell the scrollView how big its virtual world is
    [scrollView setContentSize:bigRect.size];
    
    // Add our Logo
    LogoView *logoView = [[LogoView alloc] initWithFrame:screenRect];
    [view addSubview:logoView];
    
    // Make the instance of HypnosisView the first responder so that it can respond
    // when the device is shaken
    BOOL success = [view becomeFirstResponder];
    if (success) {
        NSLog(@"Hypnosis view became first responder");
    } else {
        NSLog(@"Could not become first responder");
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return view;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
