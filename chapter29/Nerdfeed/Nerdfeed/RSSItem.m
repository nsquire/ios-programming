//
//  RSSItem.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

@synthesize parentParserDelegate, title, link, publicationDate;

#pragma mark -
#pragma mark NSCoding Protocol Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:link forKey:@"link"];
    [aCoder encodeObject:publicationDate forKey:@"publicationDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setLink:[aDecoder decodeObjectForKey:@"link"]];
        [self setPublicationDate:[aDecoder decodeObjectForKey:@"publicationDate"]];
    }
    
    return self;
}

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName
         attributes:(NSDictionary *)attributeDict
{
    WSLog(@"\t\t%@ found %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    } else if ([elementName isEqual:@"link"]) {
        currentString = [[NSMutableString alloc] init];
        [self setLink:currentString];
    } else if ([elementName isEqualToString:@"pubDate"]) {
        // Create the string, but do not put it into an ivar yet
        currentString = [[NSMutableString alloc] init];
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
    // If the pubDate ends, use a date formatter to turn it into an NSDate
    if ([elementName isEqualToString:@"pubDate"]) {
        static NSDateFormatter *dateFormatter = nil;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        }
        
        [self setPublicationDate:[dateFormatter dateFromString:currentString]];
    }
    
    currentString = nil;
    
    if ([elementName isEqual:@"item"]
        || [elementName isEqual:@"entry"]) {
        [parser setDelegate:parentParserDelegate];
    }
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setTitle:[[d objectForKey:@"title"] objectForKey:@"label"]];
    
    // Inside each entry is an array of links, each has an attribute object
    NSArray *links = [d objectForKey:@"link"];
    if ([links count] > 1) {
        NSDictionary *sampleDict = [[links objectAtIndex:1]
                                    objectForKey:@"attributes"];
        
        // The href of an attribute object is the URL for the sample audio file
        [self setLink:[sampleDict objectForKey:@"href"]];
    }
}

- (NSDictionary *)toJSONDictionary
{
    // Dictionary with href=link for song
    NSDictionary *href = [NSDictionary dictionaryWithObjectsAndKeys: link, @"href", nil];
    
    // Dictionary with attributes=href (created above)
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: href, @"attributes", nil];
    
    // Create the array of attributes. The .mpa (player link) is the second one; so just use two attributes
    NSArray *jLink = [[NSArray alloc]initWithObjects: attributes, attributes, nil];
    
    // Dictionary with label=title of item
    NSDictionary *label = [NSDictionary dictionaryWithObjectsAndKeys: title, @"label", nil];
    
    // Finally, dictionary with all of the above
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys: label, @"title", jLink, @"link", nil];
    
    //NSLog(@"---%@+++", jsonDict);
    
    return jsonDict;
}

#pragma mark -
#pragma mark - isEqual:(id)object Override

- (BOOL)isEqual:(id)object
{
    // Make sure we are comparing  an RSSItem
    if (![object isKindOfClass:[RSSItem class]]) {
        return NO;
    }
    
    // Now only return YES if the links are equal
    return [[self link] isEqual:[object link]];
}

@end
