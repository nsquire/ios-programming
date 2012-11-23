//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Nick on 11/21/12.
//
//

#import "AssetTypePicker.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "AssetTypeViewController.h"

@implementation AssetTypePicker

@synthesize item;
@synthesize popoverController;

#pragma mark View lifecycle methods

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        UIBarButtonItem *newAssetTypeButton = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                    target:self
                                                                    action:@selector(addNewAssetType:)];
        
        [[self navigationItem] setRightBarButtonItem:newAssetTypeButton];
    }

    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark TableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    if (section == 0) {
        numberOfRows = [[[BNRItemStore sharedStore] allAssetTypes] count];
    } else if (section == 1) {
        NSString *assetLabel = [[item assetType] valueForKey:@"label"];
        numberOfRows = [[[BNRItemStore sharedStore] itemsForAssetType:assetLabel] count];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
        
    if ([indexPath section] == 0) {
        NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
        
        // Use key-value coding to get the asset type's label
        NSString *assetLabel = [assetType valueForKey:@"label"];

        
        [[cell textLabel] setText:assetLabel];
        
        // Checkmark the one that is currently selected
        if (assetType == [item assetType]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    } else if ([indexPath section] == 1) {        
        // Use key-value coding to get the asset type's label
        NSString *assetLabel = [[item assetType] valueForKey:@"label"];
        NSArray *allItemsForAssetType = [[BNRItemStore sharedStore] itemsForAssetType:assetLabel];
        BNRItem *assetItem = [allItemsForAssetType objectAtIndex:[indexPath row]];
        NSString *itemLabel = [assetItem itemName];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[cell textLabel] setText:itemLabel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
        [item setAssetType:assetType];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [[self popoverController] dismissPopoverAnimated:YES];
        } else {
            [[self navigationController] popViewControllerAnimated:YES];
        }
    } else {
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Items in this Category:";
    } else {
        return nil;
    }
}

#pragma mark Custom methods

- (IBAction)addNewAssetType:(id)sender
{
    NSLog(@"In: %@", NSStringFromSelector(_cmd));
    
    AssetTypeViewController *assetTypeViewController = [[AssetTypeViewController alloc] init];
    
    [assetTypeViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:assetTypeViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
