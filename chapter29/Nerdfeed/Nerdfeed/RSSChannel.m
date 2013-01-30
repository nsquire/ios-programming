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

@synthesize parentParserDelegate, title, infoString, items;

- (id)init
{
    self = [super init];
    
    if (self) {
        // Create the container for the RSSItems this channel has
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName
         attributes:(NSDictionary *)attributeDict
{
    WSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    } else if ([elementName isEqual:@"description"]) {
        currentString = [[NSMutableString alloc] init];
        [self setInfoString:currentString];
    } else if ([elementName isEqual:@"item"]
               || [elementName isEqual:@"entry"]) {
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
    foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
    didEndElement:(NSString *)elementName
     namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
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

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    // The top-level object contains a "feed" object, which is channel
    NSDictionary *feed = [d objectForKey:@"feed"];
    
    // The feed has a title property, make this the title of our channel
    [self setTitle:[[feed objectForKey:@"title"] objectForKey:@"label"]];
    
    // The feed also has an array of entries, for each one, make a new RSSItem
    NSDictionary *entries = [feed objectForKey:@"entry"];
    for (NSDictionary *entry in entries) {
        RSSItem *i = [[RSSItem alloc] init];
        
        // Pass the entry dictionary to the item so it can grab its ivars
        [i readFromJSONDictionary:entry];
        [items addObject:i];
    }
}

- (void)trimItemTitles
{
    // Create a regular expression with the pattern: Author
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@".* :: (.*) :: .*" options:0 error:nil];
    
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
            NSLog(@"Match at {%d, %d} for %@!", r.location, r.length, itemTitle);
            
            // One capture group, so two ranges, let's verify
            if ([result numberOfRanges] == 2) {
                 // Pull out the 2nd range, which will be the capture group
                NSRange r = [result rangeAtIndex:1];
                
                // Set the title of the item to the string within the capture group
                [item setTitle:[itemTitle substringWithRange:r]];
            }
        }
    }
}

#pragma mark -
#pragma mark NSCoding Protocol Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:items forKey:@"items"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:infoString forKey:@"infoString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        items = [aDecoder decodeObjectForKey:@"items"];
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setInfoString:[aDecoder decodeObjectForKey:@"infoString"]];
    }
    
    return self;
}

#pragma mark -
#pragma mark Instance Methods

- (void)addItemsFromChannel:(RSSChannel *)otherChannel
{
    for (RSSItem *item in [otherChannel items]) {
        // If self's items does not contain this item, add it
        if (![[self items] containsObject:item]) {
            [[self items] addObject:item];
        }
    }
    
    // Sort the array of items by publication date
    [[self items] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 publicationDate] compare:[obj1 publicationDate]];
    }];
}

#pragma mark -
#pragma mark NSCopying Protocol Methods

- (id)copyWithZone:(NSZone *)zone
{
    RSSChannel *channel = [[[self class] alloc] init];
    
    [channel setTitle:[self title]];
    [channel setInfoString:[self infoString]];
    channel->items = [items mutableCopy];
    
    return channel;
}

@end
