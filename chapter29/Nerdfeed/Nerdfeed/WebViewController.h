//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@class RSSItem;

@interface WebViewController : UIViewController <ListViewControllerDelegate, UISplitViewControllerDelegate>
{
    RSSItem *item;
}

@property (nonatomic, readonly) UIWebView *webView;


@end
