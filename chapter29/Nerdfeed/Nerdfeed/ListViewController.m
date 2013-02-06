//
//  ListViewController.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "ListViewController.h"

#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"
#import "BNRFeedStore.h"

@implementation ListViewController

@synthesize webViewController;

-(id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    self = [super initWithStyle:style];
    
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        UISegmentedControl *rssTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"BNR", @"Apple", nil]];
        [rssTypeControl setSelectedSegmentIndex:0];
        [rssTypeControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [rssTypeControl addTarget:self
                           action:@selector(changeType:)
                 forControlEvents:UIControlEventValueChanged];
        [[self navigationItem] setTitleView:rssTypeControl];
        
        [self fetchEntries];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    return [[channel items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    
    if ([[BNRFeedStore sharedStore] hasItemBeenRead:item]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if ([[BNRFeedStore sharedStore] isFavorite:item]) {
        [[cell detailTextLabel] setText:@"*favorite"];
    } else {
        [[cell detailTextLabel] setText:@""];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    if (![self splitViewController]) {
        // Push the web view controller onto the navigation stack - this implicitly
        // creates the web view controller's view the first time through
        [[self navigationController] pushViewController:webViewController animated:YES];
    } else {
        // We have to create a new navigation controller, as the old one
        // was only retained by the split view controller and is now gone
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:webViewController];
        
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        
        [[self splitViewController] setViewControllers:vcs];
        
        // Make the detail view controller the delegate of the split view controller
        [[self splitViewController] setDelegate:webViewController];
    }

    // Grab the selected item
    RSSItem *entry = [[channel items] objectAtIndex:[indexPath row]];
    [[BNRFeedStore sharedStore] markItemAsRead:entry];
    
    // Immediately add a checkmark to this row
    [[[self tableView] cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
     
    [webViewController listViewController:self handleObject:entry];
}

- (void)fetchEntries
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Get a hold of the segmented control that is currently in the title view
    UIView *currentTitleView = [[self navigationItem] titleView];
    
    // Create an activity indicator and start it spinning in the nav bar
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
    
    void (^completionBlock)(RSSChannel *obj, NSError *err) =
    ^(RSSChannel *obj, NSError *err) {
        NSLog(@"Completion block called!");
        
        // When the request completes, success or failure - replace the activity
        // indicator with the segmented control
        [[self navigationItem] setTitleView:currentTitleView];
        
        if (!err) {
            channel = obj;
            [[self tableView] reloadData];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:[err localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }
    };
    
    // Initiate the request
    if (rssType == ListViewControllerRSSTypeBNR) {
        channel = [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:^(RSSChannel *obj, NSError *err) {
            // Replace the activity indicator
            [[self navigationItem] setTitleView:currentTitleView];
            
            if (!err) {
                // How many items are there currently?
                int currentItemCount = [[channel items] count];
                
                // Set our channel to the merged one
                channel = obj;
                
                // How many items are there now?
                int newItemCount = [[channel items] count];
                
                // For each new item, insert a new row. The data source
                // will take care of the rest.
                int itemDelta = newItemCount - currentItemCount;
                if (itemDelta > 0) {
                    NSMutableArray *rows = [NSMutableArray array];
                    for (int i = 0; i < itemDelta; i++) {
                        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
                        [rows addObject:ip];
                    }
                    
                    [[self tableView] insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }];
        
        [[self tableView] reloadData];
    } else if (rssType == ListViewControllerRSSTypeApple) {
        [[BNRFeedStore sharedStore] fetchTopSongs:10 withCompletion:completionBlock];
    }
    
    NSLog(@"Executing code at the end of fetchEntries");
}

- (void)showInfo:(id)sender
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    // Create the channel view controller
    ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    if ([self splitViewController]) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:channelViewController];
        
        // Create an array with our nav controller and this new VC's nav controller
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nvc, nil];
        
        // Grab a pointer to the split view controller
        // and reset its view controllers array
        [[self splitViewController] setViewControllers:vcs];
        
        // Make detail view controller the delegate of the split view controller
        [[self splitViewController] setDelegate:channelViewController];
        
        // If a row has been selected, deselect it so that a row
        // is not selected when viewing the info
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        
        if (selectedRow) {
            [[self tableView] deselectRowAtIndexPath:selectedRow animated:YES];
        }
    } else {
        [[self navigationController] pushViewController:channelViewController animated:YES];
    }
        
    // Give the view controller the channel object through the protocol message
    [channelViewController listViewController:self handleObject:channel];
}

- (void)changeType:(id)sender
{
    rssType = [sender selectedSegmentIndex];
    [self fetchEntries];
}

@end
