//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"
#import "BNRFeedStore.h"

@implementation WebViewController

@synthesize webView;

- (id)init
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    self = [super init];
    
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Favorite"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(toggleItemAsFavorite:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
    }
    
    return self;
}

- (void)loadView
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    
    // Tell web view to scale web content to fit within bounds of webview
    [wv setScalesPageToFit:YES];
    
    [self setView:wv];
}

- (UIWebView *)webView
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    return (UIWebView *)[self view];
}

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Cast the passed object to RSSItem
    item = object;
    
    // Make sure that we are really dealing with an RSSItem
    if (![item isKindOfClass:[RSSItem class]]) {
        return;
    }
    
    // Grab the info from the item and push it into the appropriate views
    NSURL *url = [NSURL URLWithString:[item link]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:req];
    
    [[self navigationItem] setTitle:[item title]];
    
    if ([[BNRFeedStore sharedStore] isFavorite:item]) {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Unfavorite"];
    } else {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Favorite"];
    }
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // If this bar button item doesn't have a title, it won't appear at all
    [barButtonItem setTitle:@"List"];
    
    // Take this bar button item and put it on the left side of our nav item
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Remove the bar button item from  our navigation item
    // We'll double check that its the correct button, even though we know it is
    if (barButtonItem == [[self navigationItem] leftBarButtonItem]) {
        [[self navigationItem] setLeftBarButtonItem:nil];
    }
}

- (void)toggleItemAsFavorite:(id)sender
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    if ([[BNRFeedStore sharedStore] isFavorite:item]) {
        [[BNRFeedStore sharedStore] removeItemAsFavorite:item];
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Favorite"];
    } else {
        [[BNRFeedStore sharedStore] markItemAsFavorite:item];
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Unfavorite"];
    }
}

@end
