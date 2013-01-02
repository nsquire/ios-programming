//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    //UIActivityIndicatorView *activityIndicator;
    UIToolbar *toolbar;
}

@property (nonatomic, readonly) UIWebView *webView;

@end
