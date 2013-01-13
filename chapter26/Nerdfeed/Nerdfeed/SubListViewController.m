//
//  SubListViewController.m
//  Nerdfeed
//
//  Created by Nick on 1/12/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "SubListViewController.h"
#import "WebViewController.h"
#import "RSSItem.h"

@implementation SubListViewController

@synthesize webViewController, subItems;

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    return [subItems count];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    RSSItem *item = [subItems objectAtIndex:[indexPath row]];
    NSLog(@"Item: %@", item);
    
    if (![self splitViewController]) {
        [[self navigationController] pushViewController:webViewController animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        [[self splitViewController] setViewControllers:vcs];
        [[self splitViewController] setDelegate:webViewController];
    }
    
    [webViewController listViewController:self handleObject:item];

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLog(@"In: %@ -> %@", [self class] , NSStringFromSelector(_cmd));
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellDetail"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellDetail"];
    }
    
    RSSItem *item = [subItems objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    
    return cell;
}

@end
