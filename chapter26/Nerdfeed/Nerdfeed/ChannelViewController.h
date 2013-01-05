//
//  ChannelViewController.h
//  Nerdfeed
//
//  Created by Nick on 1/3/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"

@class RSSChannel;

@interface ChannelViewController : UITableViewController <ListViewControllerDelegate, UITableViewDelegate, UISplitViewControllerDelegate>
{
    RSSChannel *channel;
}

@end
