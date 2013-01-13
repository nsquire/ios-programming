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
#import "SubListViewController.h"

@implementation ListViewController

@synthesize webViewController, subListViewController;

#pragma mark - View lifecycle Methods

-(id)initWithStyle:(UITableViewStyle)style
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    self = [super initWithStyle:style];
    
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                style:UIBarButtonItemStyleBordered target:self
                                                               action:@selector(showInfo:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [self fetchEntries];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    return [[channel items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    [[cell detailTextLabel] setText:[item subtitle]];
    
    if ([[item subItems] count] > 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Grab the selected item
    RSSItem *entry = [[channel items] objectAtIndex:[indexPath row]];
    
    // If the entry has sub-items, drill down to them
    if ([[entry subItems] count] > 0) {
        [subListViewController setSubItems:[entry subItems]];
        [[subListViewController tableView] reloadData];
        [[self navigationController] pushViewController:subListViewController animated:YES];
    } else {
        if (![self splitViewController]) {
            // Push the web view controller onto the navigation stack - this implicitly
            // creates the web view controller's view the first time through
            [[self navigationController] pushViewController:webViewController animated:YES];
        } else {
            // We have to create a new navigation controller, as the old one
            // was only retained by the split view controller and is now gone
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
            NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
            [[self splitViewController] setViewControllers:vcs];
            
            // Make the detail view controller the delegate of the split view controller
            [[self splitViewController] setDelegate:webViewController];
        }
    
        [webViewController listViewController:self handleObject:entry];
    }
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // We are just checking to make sure we are getting the XML
    //NSString *xmlCheck = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    //NSLog(@"xmlCheck = %@", xmlCheck);
    
    // Create the parser object with the data recieved from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // Give it a delegate
    [parser setDelegate:self];
    
    // Tell it to start parsing - the docuement will be parsed and
    // the delegate of NSXMLParser will get all of its delegate messages
    // sent to it before this line finishes execution - it is blocking
    [parser parse];
    
    // Release the connection object, we're done with it
    connection = nil;
    
    // Release the xmlData object, we're done with it
    xmlData = nil;
    
    // Reload the table.. for now, the table will be empty.
    [[self tableView] reloadData];
    
    WSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Release the connection object, we're done with it
    connection = nil;
    
    // Release the xmlData object, we're done with it
    xmlData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [av show];
}

#pragma mark - NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName
         attributes:(NSDictionary *)attributeDict
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    WSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqual:@"channel"]) {
        // If the parser saw a channel, create a new instance, store it in our ivar
        channel = [[RSSChannel alloc] init];
        
        // Give the channel object back to ourselves for later
        [channel setParentParserDelegate:self];
        
        // Set the parser's delegate to the channel object
        [parser setDelegate:channel];
    }
}

#pragma mark - Instance Methods

- (void)fetchEntries
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Create a new data container for the stuff that comes back from the service
    xmlData = [[NSMutableData alloc] init];
    
    // Construct a URL that will ask the service for what you want -
    // note we can concatenate literal strings together on multiple
    // lines in this way - this results in a single NSString instance
    NSURL *url = [NSURL URLWithString:
                  @"http://forums.bignerdranch.com/smartfeed.php?"
                  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    
    
    // Apple's News Feed URL
    //NSURL *url = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
    
    // Put that url into the NSURLRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

- (void)showInfo:(id)sender
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    if ([self splitViewController]) {
        // Setup the List button on the channel view controller, must do when in portrait mode since
        // when in landscape mode the web view controller does not have a navigation item button
        if ([[self splitViewController] interfaceOrientation] == UIDeviceOrientationPortrait ||
            [[self splitViewController] interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) {
            [[channelViewController navigationItem] setLeftBarButtonItem:[webViewController listNavButton]];
        } else {
            [[channelViewController navigationItem] setLeftBarButtonItem:nil];
        }
        
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

@end
