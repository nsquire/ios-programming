//
//  SubListViewController.h
//  Nerdfeed
//
//  Created by Nick on 1/12/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ListViewController;
@class WebViewController;
@class RSSItem;

@interface SubListViewController : UITableViewController

@property (nonatomic, strong) WebViewController *webViewController;
@property (nonatomic, strong) NSArray *subItems;

@end
