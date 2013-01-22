//
//  BNRListViewController.m
//  ClassSchedule
//
//  Created by Nick on 1/21/13.
//  Copyright (c) 2013 Nick Org. All rights reserved.
//

#import "BNRClassListViewController.h"
#import "BNRClassStore.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "BNRClassViewController.h"

@implementation BNRClassListViewController

#pragma mark -
#pragma mark Lifecycle methods

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    self = [super initWithStyle:style];
    
    if (self) {
        [self fetchClasses];
    }
    
    return self;
}

#pragma mark -
#pragma mark Instance methods

-(void)fetchClasses
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    void (^completionBlock)(RSSChannel *obj, NSError *err) =
    ^(RSSChannel *obj, NSError *err) {
        NSLog(@"In fetch completion block...");
        
        if (!err) {
            channel = obj;
            [[self tableView] reloadData];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[err localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        }
    };
    
    [[BNRClassStore sharedStore] fetchClassesWithCompletion:completionBlock];
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    NSLog(@"Count: %d", [[channel items] count]);
    
    return [[channel items] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    BNRClassViewController *classController = [[BNRClassViewController alloc] init];
    [classController setItem:item];
    
    [[self navigationController] pushViewController:classController animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"In: %@->%@", [self class], NSStringFromSelector(_cmd));
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    
    return cell;
}

@end
