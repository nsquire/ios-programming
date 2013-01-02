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
    } else if ([elementName isEqual:@"author"]) {
        currentString = [[NSMutableString alloc] init];
        [self setAuthor:currentString];
    } else if ([elementName isEqual:@"category"]) {
        currentString = [[NSMutableString alloc] init];
        [self setCategory:currentString];
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
    
    if ([elementName isEqual:@"item"]) {
        [parser setDelegate:parentParserDelegate];
    }
}

@end
