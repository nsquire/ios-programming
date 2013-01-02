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
#import "RSSCell.h"

@implementation ListViewController

@synthesize webViewController;

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        [self fetchEntries];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[channel items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RSSCell"];
    
    if (cell == nil) {
        cell = [[RSSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RSSCell"];
    }
    
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    
    [[cell titleLabel] setText:[item title]];
    [[cell authorLabel] setText:[item author]];
    [[cell categoryLabel] setText:[item category]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Push the web view controller onto the navigation stack - this implicitly
    // creates the web view controller's view the first time through
    [[self navigationController] pushViewController:webViewController animated:YES];
    
    // Grab the selected item
    RSSItem *entry = [[channel items] objectAtIndex:[indexPath row]];
    
    // Construct a URL with the link string of the item
    NSURL *url = [NSURL URLWithString:[entry link]];
    
    // Construct a request object with that URL
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Load the request into the web view
    [[webViewController webView] loadRequest:req];
    
    // Set the title of the web view controller's navigation item
    [[webViewController navigationItem] setTitle:[entry title]];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (void)fetchEntries
{
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

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
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

@end
