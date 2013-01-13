//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"

@implementation WebViewController

@synthesize webView;

- (void)loadView
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    
    // Tell web view to scale web content to fit within bounds of webview
    [wv setScalesPageToFit:YES];
    
    [self setView:wv];
}

- (UIWebView *)webView
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    return (UIWebView *)[self view];
}

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Cast the passed object to RSSItem
    RSSItem *entry = object;
    
    // Make sure that we are really dealing with an RSSItem
    if (![entry isKindOfClass:[RSSItem class]]) {
        return;
    }
    
    // Grab the info from the item and push it into the appropriate views
    NSURL *url = [NSURL URLWithString:[entry link]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:req];
    
    [[self navigationItem] setTitle:[entry title]];
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // If this bar button item doesn't have a title, it won't appear at all
    [barButtonItem setTitle:@"List"];
    
    // Take this bar button item and put it on the left side of our nav item
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
    [self setListNavButton:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Remove the bar button item from  our navigation item
    // We'll double check that its the correct button, even though we know it is
    if (barButtonItem == [[self navigationItem] leftBarButtonItem]) {
        [[self navigationItem] setLeftBarButtonItem:nil];
    }
}

@end
