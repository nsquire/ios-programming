//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webView;

- (UIWebView *)webView
{
    return (UIWebView *)[self view];
}

#pragma mark - UIViewController delegate methods

- (void)loadView
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    // Create an instance of UIWebView as large as the screen
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc] initWithFrame:screenFrame];
    
    // Tell web view to scale web content to fit within bounds of webview
    [wv setScalesPageToFit:YES];
    
    [self setView:wv];
}

- (void)viewDidLoad
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [super viewDidLoad];
    [[self webView] setDelegate:self];
    
    // Setup our web history toolbar
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect toolbarFrame = CGRectMake(0.0, 0.0, bounds.size.width, 48.0);
    toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    
    // Setup a spacer to push the buttons to the right of the UIToolbar
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // Setup go backwards and forwards web history buttons
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"backward" style:UIBarButtonItemStyleBordered target:self action:@selector(goBackwd:)];
    forwardButton = [[UIBarButtonItem alloc] initWithTitle:@"forward" style:UIBarButtonItemStyleBordered target:self action:@selector(goFwd:)];
    
    // Disable the buttons initially
    backButton.enabled = NO;
    forwardButton.enabled = NO;
    
    // Add the buttons to the toolbar and add it to our webview
    [toolbar setItems:[NSArray arrayWithObjects:spaceItem, backButton, forwardButton, nil]];
    [[self webView] addSubview:toolbar];

    //UIActivityIndicatorView *progressWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //[progressWheel setHidesWhenStopped:YES];
    //[progressWheel setCenter:CGPointMake(160.0, 160.0)];
    //activityIndicator = progressWheel;
    //[[self view] addSubview:activityIndicator];
    //[activityIndicator startAnimating];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [super viewWillDisappear:animated];
    
    if ([[self webView] isLoading]) {
        [[self webView] stopLoading];
    }
    
    [[self webView] setDelegate:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)goFwd:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    [[self webView] goForward];
}

- (void)goBackwd:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    [[self webView] goBack];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)thisWebView
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    backButton.enabled = NO;
    forwardButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    //[activityIndicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([thisWebView canGoBack]) {
        backButton.enabled = YES;
    }
    
    if ([thisWebView canGoForward]) {
        forwardButton.enabled = YES;
    }
}

- (void)webView:(UIWebView *)thisWebView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"Error...");
    
    if ([thisWebView canGoBack]) {
        backButton.enabled = YES;
    }
    
    if ([thisWebView canGoForward]) {
        forwardButton.enabled = YES;
    }
}

@end
