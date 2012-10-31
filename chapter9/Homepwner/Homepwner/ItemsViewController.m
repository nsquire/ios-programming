//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Nick on 10/27/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@implementation ItemsViewController
{
    NSArray *tableData;
}

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
        
        NSPredicate *predicate;
        
        predicate = [NSPredicate predicateWithFormat:@"valueInDollars <= 50"];
        NSArray *lessThanOrEqualToFifty = [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:predicate];
        
        predicate = [NSPredicate predicateWithFormat:@"valueInDollars > 50"];
        NSArray *greaterThanFifty = [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:predicate];
        
        tableData = [[NSArray alloc] initWithObjects:lessThanOrEqualToFifty, greaterThanFifty, nil];
        
        // Gold challenge
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
        [[self tableView] setBackgroundView:image];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[tableData objectAtIndex:section] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    }
                             
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    NSArray *sectionArray = [tableData objectAtIndex:[indexPath section]];

    if ([indexPath row] == [sectionArray count]) {
        [[cell textLabel] setText:@"No more items!"];
    } else {
        // Gold challenge
        [[cell textLabel] setFont:[UIFont systemFontOfSize:20.0]];
        
        BNRItem *p = [sectionArray objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[p description]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Gold challenge
    NSArray *sectionArray = [tableData objectAtIndex:[indexPath section]];
    
    if ([indexPath row] == [sectionArray count]) {
        return [tableView rowHeight];
    } else {
        return 60.0;
    }
}


@end
