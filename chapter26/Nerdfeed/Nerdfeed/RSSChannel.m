//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

@synthesize parentParserDelegate, title, infoString, items, subItems;

#pragma mark - View Lifecycle Methods

- (id)init
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    self = [super init];
    
    if (self) {
        // Create the container for the RSSItems this channel has
        items = [[NSMutableArray alloc] init];
        subItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    [currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName
         attributes:(NSDictionary *)attributeDict
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    WSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    } else if ([elementName isEqual:@"description"]) {
        currentString = [[NSMutableString alloc] init];
        [self setInfoString:currentString];
    } else if ([elementName isEqual:@"item"]) {
        // When we find an item, create an instance of RSSItem
        RSSItem *entry = [[RSSItem alloc] init];
        
        // Set up its parent as ourselves so we can regain control of the parser
        [entry setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:entry];
        
        // Add the item to our array and release our hold on it
        [items addObject:entry];
    }
}

- (void)parser:(NSXMLParser *)parser
    didEndElement:(NSString *)elementName
     namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // If we are in an element that we are collecting the string for,
    // this appropriately releases our hold on it and the permanent ivar keeps
    // ownership of it.  If we weren't parsing such an element, currentString
    // is nil already.
    currentString = nil;
    
    // If the element that ended was the channel, give up control to
    // who gave us control in the first place
    if ([elementName isEqual:@"channel"]) {
        [parser setDelegate:parentParserDelegate];
        [self trimItemTitles];
    }
}

#pragma mark - Instance Methods

- (void)setupSubItems:(RSSItem *)item previousItem:(RSSItem *)previousItem titleString:(NSString *)titleString replyRegex:(NSRegularExpression *)replyRegex
{
    // Logic for setting item's parent posts
    // TODO: Is there a simpler approach?
    if ([items objectAtIndex:0] != item) {
        NSArray *reMatches = [replyRegex matchesInString:titleString options:0 range:NSMakeRange(0, [titleString length])];
        if ([reMatches count] > 0) {
            NSLog(@"Found RE: match");
            NSLog(@"Prevous title: %@ -> %@, Item title: %@ -> %@", [previousItem title], previousItem, [item title], item);
            
            int length = [[previousItem title] length] >= [[item title] length] ? [[item title] length] : [[previousItem title] length];
            
            if ([[[previousItem title] substringToIndex:length] isEqualToString:[[item title] substringToIndex:length]]) {
                NSLog(@"Titles match");
                [subItems addObject:item];
                
                if ([previousItem parentPost] != nil) {
                    [item setParentPost:[previousItem parentPost]];
                    // Added subitems to item
                    [[[previousItem parentPost] subItems] addObject:item];
                } else {
                    [item setParentPost:previousItem];
                    // Added subitems to item
                    [[previousItem subItems] addObject:item];
                }
                
                NSLog(@"Item parent: %@ -> %@", [[item parentPost] title], [item parentPost]);
            }
        }
    }
}

- (void)trimItemTitles
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    // Create a regular expression with the pattern: Author
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"(.*) :: (.*) :: .*" options:0 error:nil];
    
    // Used to keep track of the previous item in the iteration belowk
    RSSItem *previousItem = nil;
    
    // Loop through every title of the items in channel
    for (RSSItem *item in items) {
        NSString *itemTitle = [item title];
        
        // Find matches in the title string.  The range
        // argument specifies how much of the title to search;
        // in this case, all of it.
        NSArray *matches = [reg matchesInString:itemTitle options:0 range:NSMakeRange(0, [itemTitle length])];
        
        // If there is a match...
        if ([matches count] > 0) {
            // Print the location of the match in the string and the string
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            NSRange r = [result range];
            NSLog(@"----------------------------------------------------------------------------");
            NSLog(@"Match at {%d, %d} for %@!", r.location, r.length, itemTitle);
            
            // Two capture groups, so three ranges, let's verify
            if ([result numberOfRanges] == 3) {
                // Pull out the 2nd range, which will be the subforum capture group
                NSRange subforumRange = [result rangeAtIndex:1];
                
                // Pull out the 3rd range, which will be the title capture group
                NSRange titleRange = [result rangeAtIndex:2];
                
                // Get a new string without the replys part - using regex
                NSString *titleString = [itemTitle substringWithRange:titleRange];
                NSRegularExpression *replyRegex = [NSRegularExpression regularExpressionWithPattern:@"\\bre: \\b" options:NSRegularExpressionCaseInsensitive error:nil];
                NSString *titleStringWithoutReply = [replyRegex stringByReplacingMatchesInString:titleString options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [titleString length]) withTemplate:@""];
                
                // Set the title of the item
                [item setTitle:titleStringWithoutReply];
                
                // Set the detail text label of the cell to the string within the subforum capture group
                [item setSubtitle:[itemTitle substringWithRange:subforumRange]];
                
                // Setup our sub-items based on entry titles
                [self setupSubItems:item previousItem:previousItem titleString:titleString replyRegex:replyRegex];
            }
        }
        
        previousItem = item;
    }
    
    [items removeObjectsInArray:subItems];
    
    NSLog(@"\nItems: %@", items);
    NSLog(@"Subitems: %@", subItems);
}

@end
