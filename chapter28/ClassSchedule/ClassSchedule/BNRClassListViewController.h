//
//  BNRListViewController.h
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel;

@interface BNRClassListViewController : UITableViewController <UITableViewDelegate>
{
    RSSChannel *channel;
}

-(void)fetchClasses;

@end
