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

#pragma mark -
#pragma mark Lifecycle methods

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
        
        // Set initial number of songs to load to 10
        selectedRowOfSongsPicker = 1;
        
        [self fetchEntries];
    }
    
    return self;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    
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
    [webViewController listViewController:self handleObject:entry];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    numberOfSongsPickerChoices = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
                                  [NSNumber numberWithInt:10],
                                  [NSNumber numberWithInt:15],
                                  [NSNumber numberWithInt:20],
                                  nil];
    
    numberOfSongsPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [numberOfSongsPicker setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    CGSize pickerSize = [numberOfSongsPicker sizeThatFits:CGSizeZero];
    [numberOfSongsPicker setFrame:[self pickerFrameWithSize:pickerSize]];
    [numberOfSongsPicker setShowsSelectionIndicator:YES];
    [numberOfSongsPicker setDelegate:self];
    [numberOfSongsPicker setDataSource:self];
    [numberOfSongsPicker selectRow:selectedRowOfSongsPicker inComponent:0 animated:YES];
    
    return numberOfSongsPicker;
}

#pragma mark -
#pragma mark Instance methods

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
        // When the request completes, success or failure - replace the activity
        // indicator with the segmented control
        [[self navigationItem] setTitleView:currentTitleView];
        
        if (!err) {
            channel = obj;
            
            if (rssType == ListViewControllerRSSTypeApple) {
                [[self tableView] setSectionHeaderHeight:162.0];
                [numberOfSongsPicker setHidden:NO];
            } else {
                [[self tableView] setSectionHeaderHeight:0.0];
                [numberOfSongsPicker setHidden:YES];
            }
            
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
        [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock];
    } else if (rssType == ListViewControllerRSSTypeApple) {
        [[BNRFeedStore sharedStore] fetchTopSongs:[[numberOfSongsPickerChoices objectAtIndex:selectedRowOfSongsPicker] intValue] withCompletion:completionBlock];
    }
}

#pragma mark -
#pragma mark Action methods

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

#pragma mark -
#pragma mark Picker methods

-(CGRect)pickerFrameWithSize:(CGSize)size
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect pickerRect = CGRectMake(0.0, screenRect.size.height - 42.0 - size.height, size.width, size.height);
    
    return pickerRect;
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    selectedRowOfSongsPicker = row;
    [self fetchEntries];
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    return [NSString stringWithFormat:@"%@", [numberOfSongsPickerChoices objectAtIndex:row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    //return [[UIScreen mainScreen] applicationFrame].size.width;
    return 260.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    return [numberOfSongsPickerChoices count];
}

@end
