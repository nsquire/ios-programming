//
//  NerdfeedAppDelegate.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "NerdfeedAppDelegate.h"
#import "ListViewController.h"
#import "WebViewController.h"
#import "SubListViewController.h"

@implementation NerdfeedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    ListViewController *lvc = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:lvc];
    
    WebViewController *wvc = [[WebViewController alloc] init];
    [lvc setWebViewController:wvc];
    
    // Setup our sub-list view controller and set its web view controller
    SubListViewController *slvc = [[SubListViewController alloc] initWithStyle:UITableViewStylePlain];
    [slvc setWebViewController:wvc];
    
    // Set the list view controllers sub-list view controller
    [lvc setSubListViewController:slvc];
    
    // Check to make sure we're running on the iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // wvc must be in navigation controller
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:wvc];
        
        NSArray *vcs = [NSArray arrayWithObjects:masterNav, detailNav, nil];
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        
        // Set the delegate of the split view controller to the detail view controller
        [svc setDelegate:wvc];
        
        [svc setViewControllers:vcs];
        
        // Set the root view controller of the window to the split view controller
        [[self window] setRootViewController:svc];
    } else {
        // On non-iPad devices, go with the old version and just add the
        // single nav controller to the window
        [[self window] setRootViewController:masterNav];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
