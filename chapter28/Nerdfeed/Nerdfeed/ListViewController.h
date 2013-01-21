//
//  ListViewController.h
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel;
@class WebViewController;

typedef enum {
    ListViewControllerRSSTypeBNR,
    ListViewControllerRSSTypeApple
} ListViewControllerRSSType;

@interface ListViewController : UITableViewController <UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    RSSChannel *channel;
    ListViewControllerRSSType rssType;
    NSArray *numberOfSongsPickerChoices;
    UIPickerView *numberOfSongsPicker;
    int selectedRowOfSongsPicker;
}

@property (nonatomic, strong) WebViewController *webViewController;

- (void)fetchEntries;

@end


@protocol ListViewControllerDelegate

- (void)listViewController:(ListViewController *)lvc handleObject:(id)object;

@end
