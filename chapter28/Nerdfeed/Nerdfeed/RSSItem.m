//
//  RSSItem.m
//  Nerdfeed
//
//  Created by Nick on 12/31/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

@synthesize parentParserDelegate, title, link;

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

@end
